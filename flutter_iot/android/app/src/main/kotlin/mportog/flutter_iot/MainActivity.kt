package mportog.flutter_iot
import androidx.annotation.NonNull;
import com.pubnub.api.PNConfiguration
import com.pubnub.api.PubNub
import com.pubnub.api.callbacks.SubscribeCallback
import com.pubnub.api.models.consumer.PNStatus
import com.pubnub.api.models.consumer.pubsub.PNMessageResult
import com.pubnub.api.models.consumer.pubsub.PNPresenceEventResult
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

class MainActivity: FlutterActivity() {
   override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
       GeneratedPluginRegistrant.registerWith(flutterEngine);

       val pnConfiguration = PNConfiguration()
       pnConfiguration.setSubscribeKey("sub-c-052a7e96-86f4-11e9-9f15-ba4fa582ffed")
       pnConfiguration.setPublishKey("pub-c-b3c97c3a-4572-44ac-91d4-942e9dcecc86")

       val pubnub = PubNub(pnConfiguration)

       pubnub.addListener(object : SubscribeCallback() {
           override fun status(pubnub: PubNub, status: PNStatus) {}

           override fun message(pubnub: PubNub, message: PNMessageResult) {
               val receivedMessageObject = message.getMessage()

               Log.e("pubnub", "recebe mensagem " + receivedMessageObject.toString())
               if (message.channel.equals("flutter_iot_lamp")){
                   this@MainActivity.runOnUiThread(java.lang.Runnable {
                       MethodChannel(
                               flutterEngine.getDartExecutor().getBinaryMessenger(),
                               "flutter_iot_lamp").invokeMethod(
                               "messageFromLamp",
                               receivedMessageObject.toString());
                   })
               }


           }

           override fun presence(pubnub: PubNub, presence: PNPresenceEventResult) {

           }
       })

       pubnub.subscribe().channels(Arrays.asList<String>("flutter_iot_lamp")).execute()
   }
}
