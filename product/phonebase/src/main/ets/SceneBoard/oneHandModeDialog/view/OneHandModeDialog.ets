/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BusinessError } from '@ohos.base';
import { commonEventManager } from '@kit.BasicServicesKit';
import { call, observer } from '@kit.TelephonyKit';
import { CustomContentDialog } from '@kit.ArkUI'
import lottie, { AnimationItem } from '@ohos/lottie'
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import common from '@ohos.app.ability.common';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { fileIo } from '@kit.CoreFileKit';
import lazy { TipsJumpUtils } from '../../scenemanager/multiwindow/Guidance/JumpTips';
import { OneHandDialogConstants } from '../config/OneHandModeDialogConstants';
import { KeyCodeConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';

const TAG: string = 'OneHandModeDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
let storage = LocalStorage.getShared();

@Entry(storage)
@Component
struct OneHandModeDialog {
  private session?: UIExtensionContentSession = storage.get('session') as UIExtensionContentSession;
  private renderingContextSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasRendering?: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingContextSettings);
  private animationItem?: AnimationItem;
  private lottieData?: object;
  private subscriber?: commonEventManager.CommonEventSubscriber;
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      primaryTitle: $r('app.string.one_handed_mode_diag_title'),
      secondaryTitle: $r('app.string.one_handed_mode_diag_content'),
      contentBuilder: () => {
        this.buildContent();
      },
      buttons: [{
        value: $r('app.string.one_handed_mode_diag_confirm'),
        buttonStyle: ButtonStyleMode.TEXTUAL,
        action: this.onAccept
      }, {
        value: $r('app.string.one_handed_mode_diag_cancel'),
        buttonStyle: ButtonStyleMode.TEXTUAL,
        action: this.onCancel
      }],
    }),
    cancel: this.onCancel,
    autoCancel: true,
    alignment: DialogAlignment.Center,
  });

  private homeKeyOption: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_HOME,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  private recentKeyOption: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_RECENT,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  private callStateChangeCallback: (data: observer.CallStateInfo) => void = (data: observer.CallStateInfo) => {
    log.showInfo(`on callStateChange, data: ${data?.state}`);
    if (data?.state === call.CallState.CALL_STATE_RINGING) {
      // 来电时关闭弹框
      this.session?.terminateSelf();
    }
  }

  private screenLockEventCallback = (err: BusinessError, eventData: commonEventManager.CommonEventData): void => {
    if (err) {
      log.showError(`screenLockEventCallback, code:${err?.code}, message:${err?.message}`);
      return;
    }
    if (eventData?.event === commonEventManager.Support.COMMON_EVENT_SCREEN_LOCKED) {
      log.showInfo('on screen locked event');
      // 锁屏关闭弹框
      this.session?.terminateSelf();
    }
  }

  private inputConsumerCallback: Callback<inputConsumer.KeyOptions> = (keyOptions: inputConsumer.KeyOptions) => {
    log.showInfo(`inputConsumerCallback key: ${keyOptions?.finalKey}`);
    // home、recent按键关闭弹框
    this.session?.terminateSelf();
  }

  private onCancel(): void {
    log.showInfo('Callback when the cancel button is clicked');
    this.session?.terminateSelf();
  }

  private onAccept(): void {
    log.showInfo('Callback when the confirm button is clicked');
    TipsJumpUtils.jumpTips(getContext(this) as common.UIAbilityContext, OneHandDialogConstants.TIP_FUN_NUM,
      OneHandDialogConstants.TIP_FUN_TYPE);
  }

  private loadLottieData(): boolean {
    try {
      let lottieStr = fileIo.readTextSync(OneHandDialogConstants.LOTTIE_DATA_PATH);
      this.lottieData = JSON.parse(lottieStr);
      if (!this.lottieData) {
        log.showError('parse lottieStr failed');
        return false;
      }
      log.showInfo(`loadLottieData success`);
    } catch (err) {
      log.showError(`loadLottieData failed, errCode: ${err?.code}`);
      return false;
    }
    return true;
  }

  /**
   * 订阅通话状态变化事件
   */
  private subscribeCallStateChange(): void {
    log.showInfo('subscribe call state change event');
    try {
      observer.on('callStateChange', this.callStateChangeCallback);
    } catch (err) {
      log.showError(`subscribe call state observer, err: ${err?.code}, err: ${err?.message}`);
    }
  }

  /**
   * 取消订阅通话状态变化事件
   */
  private unSubscribeCallStateChange(): void {
    log.showInfo('unsubscribe call state change event');
    try {
      observer.off('callStateChange', this.callStateChangeCallback);
    } catch (err) {
      log.showError(`unsubscribe call state observer, err: ${err?.code}, err: ${err?.message}`);
    }
  }

  /**
   * 订阅锁屏事件
   */
  private async subscribeScreenLockEvent(): Promise<void> {
    log.showInfo('subscribe screen lock event');
    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [commonEventManager.Support.COMMON_EVENT_SCREEN_LOCKED]
    };
    try {
      this.subscriber = await commonEventManager.createSubscriber(subscribeInfo);
      commonEventManager.subscribe(this.subscriber, this.screenLockEventCallback);
    } catch (err) {
      log.showError(`Failed to create subscriber. Code is ${err?.code}, message is ${err?.message}`);
    }

  }

  /**
   * 取消订阅锁屏事件
   */
  private unSubscribeScreenLockEvent(): void {
    if (this.subscriber) {
      try {
        commonEventManager.unsubscribe(this.subscriber);
      } catch (err) {
        log.showError(`Failed to unsubscribe. Code is ${err?.code}, message is ${err?.message}`);
      }
    }
  }

  private subscribeKeyEventCallBack(): void {
    inputConsumer.on('key', this.homeKeyOption, this.inputConsumerCallback);
    inputConsumer.on('key', this.recentKeyOption, this.inputConsumerCallback);
  }

  private unSubscribeKeyEventCallBack(): void {
    inputConsumer.off('key', this.homeKeyOption);
    inputConsumer.off('key', this.recentKeyOption);
  }

  onPageShow(): void {
    log.showInfo('onPageShow');
    this.session?.setReceiveDataCallback((data: Record<string, Object>) => {
      Object.keys(data).forEach(key => {
        if (key === 'isGestureBack') {
          log.showInfo('recv GestureBack, exit');
          // 收到返回手势事件关闭弹框
          this.session?.terminateSelf();
        }
      });
    });
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.dialogController.open();
    this.subscribeCallStateChange();
    this.subscribeScreenLockEvent();
    this.subscribeKeyEventCallBack();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.unSubscribeCallStateChange();
    this.unSubscribeScreenLockEvent();
    this.unSubscribeKeyEventCallBack();
  }

  private loadAnimation(): void {
    if (!this.loadLottieData()) {
      log.showError('loadLottieData failed, exit');
      this.session?.terminateSelf();
    }
    this.animationItem = lottie.loadAnimation({
      container: this.canvasRendering,
      renderer: 'canvas',
      loop: true,
      autoplay: true,
      animationData: this.lottieData,
      name: OneHandDialogConstants.LOTTIE_NAME,
      packageName: OneHandDialogConstants.LOTTIE_PKG_NAME,
    });
  }

  build() {
    Column()
    .height('100%')
    .width('100%')
  }

  @Builder
  buildContent(): void {
    Canvas(this.canvasRendering)
      .onReady(() => {
        log.showInfo('canvas ready');
        this.loadAnimation();
      })
      .onDisAppear(() => {
        log.showInfo('canvas disAppear');
        // 组件移除时，可销毁动画资源
        this.animationItem?.destroy();
        lottie.destroy(OneHandDialogConstants.LOTTIE_NAME);
        this.session?.terminateSelf();
      })
    .width('100%')
    .height('884px')
  }
}