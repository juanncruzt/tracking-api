<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\TrackingHistory;
use App\ShippingMessages;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

class WebhookController extends Controller
{
    /*{
       "Token":"P25BMY6BGW",
       "CodigoTransaccion":"BDZBLD",
       "IdEstado":1308,
       "TxtEstado":"Devolución a Remitente",
       "Order":"12333123",
    }*/
    
    public function getStatusPickit(Request $request)
    {
        try{
            $jsonRequest = $request->getContent();
            $json = json_decode($jsonRequest,true);
            
            $token= $json['Token'];
            $codTransaccion = $json['CodigoTransaccion'];
            $idEstado = $json['IdEstado'];
            $txtEstado = $json['TxtEstado'];  
            $order= $json['Order']; 
            
            Storage::disk('local')->put($token.'-'.(new \DateTime())->format('Y-m-d-H-i-s').'-WEBHOOK-PICKIT.json', $jsonRequest);
            
            if(!$order){
                return response()->json(["success" => false, "error" => "Error al obtener el Nº de orden del envio de Pickit."], 501);
            }
            
            $newHistory = new TrackingHistory();
            $newHistory->id_tracking = $order;
            $newHistory->id_carrier = 3;
            
            $shippingMessage = ShippingMessages::where('carrier_status_id',$idEstado)->where('carrier_id',3)->first();
            
            if(!$shippingMessage){
                return response()->json(["success" => false, "error" => "Error al obtener el estado del envio de Pickit."], 501);
            }
            
            $newHistory->id_shipping_messages = $shippingMessage->id;
            $newHistory->save();
        } catch (Exception $e) {
            return response()->json(["success" => false, "error" => "Error al obtener guardar el estatus del envio de Pickit."], 501);
        }
        
        return response()->json(["success" => true, "msg" => 'Historial de Pickit actualizado correctamente']);
    }
}
