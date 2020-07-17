<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateShippingMessagesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('shipping_messages', function (Blueprint $table) {
            $table->id();
            $table->timestamps();
            $table->integer('carrier_id');
            $table->text('carrier_status_id');
            $table->text('description_carrier_status');
            $table->text('message');
            $table->text('next_status');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('shipping_messages');
    }
}
