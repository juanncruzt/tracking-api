<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Carrier;
use App\ShippingMessages;
use Illuminate\Support\Facades\Redis;

/**
* @OA\Info(title="TrackingApi v1.0", version="1.0")
*
*/
class ApiController extends Controller
{
    
    /**
    * @OA\Get(
    *     path="/api/v1/redis/test",
    *     summary="Test redis",
    *     tags={"General"},
    *     @OA\Response(
    *         response=200,
    *         description="Test redis."
    *     ),
    *     @OA\Response(
    *         response="default",
    *         description="Ha ocurrido un error."
    *     )
    * )
    */
    public function testRedis()
    {
        $name=null;
        $success=false;
        
        $this->setRedis('name','Taylor');
        $result = $this->getRedis('name');
        
        if($result != ""){
            $name = $result;
            $success=true;
        }

        return response()->json(["success" => $success, "name" => $name]);
    }
    
    
    private function setRedis($name,$val){
        $redis = Redis::connection();
        $redis->set($name,$val);
    }
    
    private function getRedis($name){
        $redis = Redis::connection();
        $result = $redis->get($name);
        
        return $result;
    }
    
    
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
    *         name="apiKey",
    *         in="query",
    *         description="API key",
    *         required=true,
    *         style="form"
    *     ),
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
        $trackApiKey = env('TRACKING_API_KEY');
        $apiKey = $request->apiKey;
        
        if($apiKey != $trackApiKey){
            return response()->json(['error' => 'Credenciales inválidas: ' . $apiKey], 403);
        }
        
        $arrayHistory = [];
        $history = null;
        $carrier = null;
        $icon = null;
        $error = null;
        $success = false;
        $client = new \GuzzleHttp\Client();
        
        try{
            //guardo busco en redis, si no encuentra sigo
            $resultRedis = $this->getRedis($trackingId);
            
            if($resultRedis != ''){
                $resultRedis = json_decode($resultRedis);
                
                $carrier = $resultRedis->carrier;
                $icon = $resultRedis->icon;
                $arrayHistory = $resultRedis->history;
                $success = true;
            }else{
                
                //despues pruebo con chazki
                $resultChazki = $this->searchTrackingChazki($trackingId);
                
                if($resultChazki['success']){
                    $arrayHistory = $resultChazki['history'];
                    $icon = $resultChazki['icon'];
                    $success = true;
                    $carrier = "Chazki";
                }else{
                    $error = $resultChazki['error'];
                    //en caso de error, pruebo con andreani
                    
                    $resultAndreani = $this->searchTrackingAndreani($trackingId);
                    if($resultAndreani['success']){
                        $arrayHistory = $resultAndreani['history'];
                        $icon = $resultAndreani['icon'];
                        $success = true;
                        $carrier = "Andreani";
                    }else{
                        $error = $error." ".$resultAndreani['error'];
                    }
                }
                
                if($success){
                    //guardo array en redis solo si no existe
                    $redis = [];
                    $redis['carrier'] = $carrier;
                    $redis['icon'] = $icon;
                    $redis['history'] = $arrayHistory;
                    $this->setRedis($trackingId,json_encode($redis));
                }
                
                
            }
        }catch (Exception $e) {
            return response()->json(["success" => false, "error" => "Error al obtener el historial del envío."], 501);
        }
        
        if(!$success){
            return response()->json(["success" => false, "error" => $error." Por favor, inténtelo de nuevo más tarde!"]);
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
        $arrayHistory = null;
        $history = null;
        $client = new \GuzzleHttp\Client();
        $success = false;
        try{
            $result = $this->searchTrackingAndreani($trackingId);
            
            if($result['success']){
                $arrayHistory = $result['history'];
                $success = true;
            }else{
                return response()->json(["success" => false, "error" => $result['error']], 501);
            }
        }catch (Exception $e) {
            return response()->json(["success" => false, "error" => "Ocurrió un error en el servicio de Andreani."], 501);
        }
        
        return response()->json(["success" => $success, "history" => $arrayHistory]);
    }
    
    private function searchTrackingAndreani($trackingId){
        $arrayHistory = [];
        $history = null;
        $icon = null;
        $client = new \GuzzleHttp\Client();
        
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
                        $lastStatus = null;
                        foreach($history as $h){
                            $arr = [];
                            $date = $h->Fecha;
                            
                            $date = \DateTime::createFromFormat("Y-m-d\TH:i:s", $date);
                            $date = $date->format('d/m/Y H:i');
                            $status = $h->EstadoId;
                            $shippingMessage = ShippingMessages::where('carrier_status_id',$status)->where('carrier_id',1)->first();
                            
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
                            
                            
                            if($lastStatus != $status){
                                array_push($arrayHistory,$arr);
                            }
                            
                            $lastStatus = $status;
                        }
                    }
                    
                    $carrier = "Andreani";
                }else if($response->getStatusCode() == 404){   
                    return array('success' => false,'error' => "No se encontró el envío en Andreani.");
                }else{
                    return array('success' => false,'error' => "Ocurrió un error en el servicio de Andreani.");
                }
                
            }else if($responseOrden->getStatusCode() == 404){   
                return array('success' => false,'error' => "No se encontró el envío en Andreani.");
            }else{
                return array('success' => false,'error' => "Ocurrió un error en el servicio de Andreani.");
            }
        }else{
            return array('success' => false,'error' => "Ocurrió un error en el servicio de Andreani.");
        }
        return array('success' => true,'history' => $arrayHistory,'icon'=>$icon);
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
        $arrayHistory = null;
        $history = null;
        $client = new \GuzzleHttp\Client();
        $success = false;
        try{
            $result = $this->searchTrackingChazki($trackingId);
            
            if($result['success']){
                $arrayHistory = $result['history'];
                $success = true;
            }else{
                return response()->json(["success" => false, "error" => $result['error']], 501);
            }
        }catch (Exception $e) {
            return response()->json(["success" => false, "error" => "Ocurrió un error en el servicio de Chazki."], 501);
        }
        
        return response()->json(["success" => $success, "history" => $arrayHistory]);
    }
    
    private function searchTrackingChazki($trackingId){
        $arrayHistory = [];
        $history = null;
        $icon = null;
        $client = new \GuzzleHttp\Client();

        $response = $client->get(env('CHAZKI_API_BASE_URL').'/shipment/NES'.$trackingId.'?key='.env('CHAZKI_API_KEY'),['http_errors' => false]);
            
        if($response->getStatusCode() == 200){
            //es chazki
            $response = $response->getBody();
            $response = json_decode($response);
            $history = array_reverse($response->history);
            
            //foreach de history y consulto en ShippingMessages
            if($history){
                $x = true;
                $lastStatus = null;
                foreach($history as $h){
                    $arr = [];
                    $date = $h->date;
                    
                    $date = \DateTime::createFromFormat("Y-m-d\TH:i:s.u+", $date);
                    $date = $date->format('d/m/Y H:i');
                    
                    $status = strtoupper($h->status);
                    $shippingMessage = ShippingMessages::where('carrier_status_id',$status)->where('carrier_id',2)->first();
                    
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
                    
                    
                    if($lastStatus != $status){
                        array_push($arrayHistory,$arr);
                    }
                    
                    $lastStatus = $status;
                }
            }
        }else if($response->getStatusCode() == 404){   
            return array('success' => false,'error' => "No se encontró el envío en Chazki.");
        }else{
            return array('success' => false,'error' => "Ocurrió un error en el servicio de Chazki.");
        }
        
        return array('success' => true,'history' => $arrayHistory,'icon'=>$icon);
    }
    
}
