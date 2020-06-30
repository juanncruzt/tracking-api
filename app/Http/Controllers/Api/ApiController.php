<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Carrier;
use App\ShippingMessages;

/**
* @OA\Info(title="TrackingApi v1.0", version="1.0")
*
*/
class ApiController extends Controller
{
    
    /**
    * @OA\Get(
    *     path="/api/v1/carriers/get",
    *     summary="Mostrar carriers",
    *     tags={"General"},
    *     @OA\Response(
    *         response=200,
    *         description="Mostrar todos los carriers."
    *     ),
    *     @OA\Response(
    *         response="default",
    *         description="Ha ocurrido un error."
    *     )
    * )
    */
    public function getCarriers()
    {
        return Carrier::all();
    }
    
    /**
    * @OA\Get(
    *     path="/api/v1/carriers-messages/all",
    *     summary="Mostrar mensajes de carriers",
    *     tags={"General"},
    *     @OA\Response(
    *         response=200,
    *         description="Mostrar todos los mensajes de carriers."
    *     ),
    *     @OA\Response(
    *         response="default",
    *         description="Ha ocurrido un error."
    *     )
    * )
    */
    public function getCarrierMessages()
    {
        return ShippingMessages::all();
    }
    
    /**
    * @OA\Get(
    *     path="/api/v1/tracking/{trackingId}",
    *     summary="Obtener tracking",
    *     tags={"General"},
    *     @OA\Parameter(
    *         name="trackingId",
    *         in="path",
    *         description="ID de tracking",
    *         required=true
    *     ),
    *     @OA\Response(
    *         response=200,
    *         description="Obtener tracking de Chazki"
    *     ),
    *     @OA\Response(
    *         response="default",
    *         description="Ha ocurrido un error."
    *     )
    * )
    */
    public function getTracking(Request $request, $trackingId)
    {
        $arrayHistory = [];
        $history = null;
        $carrier = null;
        $icon = null;
        $client = new \GuzzleHttp\Client();
        
        try{
            //primero pruebo con chazki
            $response = $client->get(env('CHAZKI_API_BASE_URL').'/shipment/NES'.$trackingId.'?key='.env('CHAZKI_API_KEY'),['http_errors' => false]);
            
            if($response->getStatusCode() == 200){
                //es chazki
                $response = $response->getBody();
                $response = json_decode($response);
                $history = array_reverse($response->history);
                
                //foreach de history y consulto en ShippingMessages
                if($history){
                    $x = true;
                    foreach($history as $h){
                        $arr = [];
                        $date = $h->date;
                        
                        $date = \DateTime::createFromFormat("Y-m-d\TH:i:s.u+", $date);
                        $date = $date->format('d/m/Y H:i');
                        
                        $status = strtoupper($h->status);
                        $shippingMessage = ShippingMessages::where('carrier_status_id',$status)->first();
                        
                        if($shippingMessage){
                            $arr['fecha']  = $date;
                            $arr['estado']  = $status;
                            $arr['descripcion']  = $shippingMessage->message;
                            $arr['siguiente']  = $shippingMessage->next_status;
                            
                            if($x){
                                $icon = $shippingMessage->icon;
                                $x = false;
                            }
                        }else{
                            $arr['fecha']  = $date;
                            $arr['estado']  = $status;
                            $arr['descripcion']  = $status;
                            $arr['siguiente']  = "X";
                        }
                        
                        array_push($arrayHistory,$arr);
                    }
                }
                
                $carrier = "Chazki";
            }else{
                //sino pruebo con Andreani
                $responseLogin = $client->get(env('ANDREANI_API_BASE_URL').'/login', ['headers' => ['Authorization' => 'Basic bmVzc3ByZXNvX3dzOkFiZGgyMzQhIWQ=']]);
                
                if($responseLogin->getStatusCode() == 200){
                    $apiKey = $responseLogin->getHeader('X-Authorization-token');
                    $apiKey = $apiKey[0];
                    
                    //primero obtener el numero de envio de aca y despues el trackeo
                    //https://api.andreani.com/v1/envios?codigoCliente=CL0008157&idDeProducto=37026829
                    $responseOrden = $client->get(env('ANDREANI_API_BASE_URL').'/v1/envios?codigoCliente=CL0008157&idDeProducto='.$trackingId,['http_errors' => false,'headers' => ['x-authorization-token' => $apiKey]]);
                    if($responseOrden->getStatusCode() == 200){
                        $responseOrden = $responseOrden->getBody();
                        $responseOrden = json_decode($responseOrden);
                        $trackingId = $responseOrden->envios[0]->numeroDeTracking;
                        
                        $response = $client->get(env('ANDREANI_API_BASE_URL').'/v1/envios/'.$trackingId.'/trazas',['http_errors' => false,'headers' => ['x-authorization-token' => $apiKey]]);
                        
                        if($response->getStatusCode() == 200){
                            $response = $response->getBody();
                            $response = json_decode($response);
                            $history = array_reverse($response->eventos);
                            
                            if($history){
                                $x = true;
                                foreach($history as $h){
                                    $arr = [];
                                    $date = $h->Fecha;
                                    
                                    $date = \DateTime::createFromFormat("Y-m-d\TH:i:s", $date);
                                    $date = $date->format('d/m/Y H:i');
                                    $status = $h->EstadoId;
                                    $shippingMessage = ShippingMessages::where('carrier_status_id',$status)->first();
                                    
                                    if($shippingMessage){
                                        $arr['fecha']  = $date;
                                        $arr['estado']  = $shippingMessage->description_carrier_status;
                                        $arr['descripcion']  = $shippingMessage->message;
                                        $arr['siguiente']  = $shippingMessage->next_status;
                                        
                                        if($x){
                                            $icon = $shippingMessage->icon;
                                            $x = false;
                                        }
                                    }else{
                                        $arr['fecha']  = $date;
                                        $arr['estado']  = $status;
                                        $arr['descripcion']  = $status;
                                        $arr['siguiente']  = "X";
                                    }
                                    
                                    
                                    array_push($arrayHistory,$arr);
                                }
                            }
                            
                            $carrier = "Andreani";
                        }else{
                            return response()->json(["success" => false, "error" => "No se pudo encontrar ningún envío."], 501);
                        }
                    }else{
                        return response()->json(["success" => false, "error" => "No se pudo encontrar ninguna orden asociada."], 501);
                    }
                }else{
                    return response()->json(["success" => false, "error" => "Error al loguearse en la API de Andreani."], 501);
                }
            }
            
        }catch (Exception $e) {
            return response()->json(["success" => false, "error" => "Error al obtener el historial del envío."], 501);
        }
        
        return response()->json(["success"=>true,"carrier"=>$carrier,"icon"=>$icon,"history"=>$arrayHistory]);
    }
    
    /**
    * @OA\Get(
    *     path="/api/v1/carriers-messages/andreani",
    *     summary="Mostrar mensajes de Andreani",
    *     tags={"Andreani"},
    *     @OA\Response(
    *         response=200,
    *         description="Mostrar todos los mensajes de Andreani."
    *     ),
    *     @OA\Response(
    *         response="default",
    *         description="Ha ocurrido un error."
    *     )
    * )
    */
    public function getMessagesAndreani()
    {
        return ShippingMessages::where('carrier_id',1)->get();
    }
    
    /**
    * @OA\Post(
    *     path="/api/v1/tracking/andreani/{trackingId}",
    *     summary="Obtener tracking de Andreani",
    *     tags={"Andreani"},
    *     @OA\Parameter(
    *         name="trackingId",
    *         in="path",
    *         description="ID de tracking",
    *         required=true
    *     ),
    *     @OA\Response(
    *         response=200,
    *         description="Obtener tracking de Andreani"
    *     ),
    *     @OA\Response(
    *         response="default",
    *         description="Ha ocurrido un error."
    *     )
    * )
    */
    public function getTrackingAndreani(Request $request, $trackingId)
    {
        $arrayHistory = [];
        $history = null;
        $client = new \GuzzleHttp\Client();
        
        try{
            $responseLogin = $client->get(env('ANDREANI_API_BASE_URL').'/login', ['headers' => ['Authorization' => 'Basic bmVzc3ByZXNvX3dzOkFiZGgyMzQhIWQ=']]);
            if($responseLogin->getStatusCode() == 200){
                $apiKey = $responseLogin->getHeader('X-Authorization-token');
                $apiKey = $apiKey[0];
                
                $response = $client->get(env('ANDREANI_API_BASE_URL').'/v1/envios/'.$trackingId.'/trazas',['http_errors' => false,'headers' => ['x-authorization-token' => $apiKey]]);
                
                
                if($response->getStatusCode() == 200){
                    $response = $response->getBody();
                    $response = json_decode($response);
                    /*$history =  json_decode('{
                                  "eventos":[{
                                    "Fecha":"2019-04-11T11:18:47",
                                    "Estado":"Pendiente de ingreso",
                                    "EstadoId":22,
                                    "Motivo":null,
                                    "MotivoId":0,
                                    "Submotivo":null,
                                    "SubmotivoId":0,
                                    "Sucursal":"",
                                    "SucursalId":0,
                                    "Ciclo":""
                                  },{
                                    "Fecha":"2019-04-13T10:05:32",
                                    "Estado":"Ingreso al circuito operativo",
                                    "EstadoId":23,
                                    "Motivo":null,
                                    "MotivoId":0,
                                    "Submotivo":null,
                                    "SubmotivoId":0,
                                    "Sucursal":"",
                                    "SucursalId":121,
                                    "Ciclo":""
                                  }]
                                }');*/
                    
                    //foreach de history y consulto en ShippingMessages
                    //$history = array_reverse($response);
                    
                    print_r(json_encode($response));
                    die('*--');
                    if($history){
                        foreach($history as $h){
                            $arr = [];
                            $date = $h->Fecha;
                            $status = $h->EstadoId;
                            $shippingMessage = ShippingMessages::where('carrier_status_id',$status)->first();
                            
                            if($shippingMessage){
                                $arr['fecha']  = $date;
                                $arr['estado']  = $shippingMessage->description_carrier_status;
                                $arr['descripcion']  = $shippingMessage->message;
                                $arr['siguiente']  = $shippingMessage->next_status;
                            }else{
                               $arr['fecha']  = $date;
                                $arr['estado']  = $status;
                                $arr['descripcion']  = $status;
                                $arr['siguiente']  = "X";
                            }
                            
                            array_push($arrayHistory,$arr);
                        }
                    }
                }else{
                    return response()->json(["success" => false, "error" => "El tracking no pertenece a ningun envío de Andreani."], 501);
                }
                
                
            }else{
                return response()->json(["success" => false, "error" => "Error al loguearse en la API de Andreani."], 501);
            }
            
        }catch (Exception $e) {
            return response()->json(["success" => false, "error" => "Error al obtener el historial del envío de Andreani."], 501);
        }
        
        return response()->json(["success" => true, "history" => $arrayHistory]);
    }
    
    /**
    * @OA\Get(
    *     path="/api/v1/carriers-messages/chazki",
    *     summary="Mostrar mensajes de Chazki",
    *     tags={"Chazki"},
    *     @OA\Response(
    *         response=200,
    *         description="Mostrar todos los mensajes de Chazki."
    *     ),
    *     @OA\Response(
    *         response="default",
    *         description="Ha ocurrido un error."
    *     )
    * )
    */
    public function getMessagesChazki()
    {
        return ShippingMessages::where('carrier_id',2)->get();
    }
    
    /**
    * @OA\Post(
    *     path="/api/v1/tracking/chazki/{trackingId}",
    *     summary="Obtener tracking de Chazki",
    *     tags={"Chazki"},
    *     @OA\Parameter(
    *         name="trackingId",
    *         in="path",
    *         description="ID de tracking",
    *         required=true
    *     ),
    *     @OA\Response(
    *         response=200,
    *         description="Obtener tracking de Chazki"
    *     ),
    *     @OA\Response(
    *         response="default",
    *         description="Ha ocurrido un error."
    *     )
    * )
    */
    public function getTrackingChazki(Request $request, $trackingId)
    {
        $arrayHistory = [];
        $history = null;
        $client = new \GuzzleHttp\Client();
        
        try{
            $response = $client->get(env('CHAZKI_API_BASE_URL').'/shipment/NES'.$trackingId.'?key='.env('CHAZKI_API_KEY'),['http_errors' => false]);
            print_r($response);
            die('---');
            if($response->getStatusCode() == 200){
                $response = $response->getBody();
                $response = json_decode($response);
                $history = array_reverse($response->history);
            
                //foreach de history y consulto en ShippingMessages
                if($history){
                    foreach($history as $h){
                        $arr = [];
                        $date = $h->date;
                        
                        $status = strtoupper($h->status);
                        
                        $shippingMessage = ShippingMessages::where('carrier_status_id',$status)->first();
                        
                        $arr['fecha']  = $date;
                        $arr['estado']  = $status;
                        $arr['descripcion']  = $shippingMessage->message;
                        $arr['siguiente']  = $shippingMessage->next_status;
                        
                        array_push($arrayHistory,$arr);
                    }
                }
            }else{
                return response()->json(["success" => false, "error" => "El tracking no pertenece a ningun envío de Chazki."], 501);
            }
            
        }catch (Exception $e) {
            return response()->json(["success" => false, "error" => "Error al obtener el historial del envío de Chazki."], 501);
        }
        
        return response()->json(["success" => true, "history" => $arrayHistory]);
    }
}
