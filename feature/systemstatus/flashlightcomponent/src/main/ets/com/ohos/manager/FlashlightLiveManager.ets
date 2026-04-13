/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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


import { FlashlightLiveEvent } from '@ohos/systemuicommon';
import {
  LogDomain,
  LogHelper,
  PixelMapUtil, SingletonHelper
} from '@ohos/basicutils';
import { EvtBus, GlobalContext } from '@ohos/frameworkwrapper';
import notificationManager from '@ohos.notificationManager';
import type context from '@ohos.app.ability.common';
import image from '@ohos.multimedia.image';
import camera from '@ohos.multimedia.camera';
import type featureAbility from '@ohos.ability.featureAbility';
import { SysTypeCode } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import { LiveType } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCommonModel';
import Constants from '../common/Constants';
import {
  NotificationBase,
  NotificationDataManager,
} from '@ohos/systemuicommon/newTsIndex';
import { ResourceVm } from '@ohos/systemuicommon/newIndex';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';

const TAG = 'FlashlightLiveManager';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const TORCH_MODE_OFF: number = 0;
const TORCH_MODE_ON: number = 1;
/**
 * 手电筒实况管理
 *
 */
export class FlashlightLiveManager {
  // /**
  //  * 获取单例
  //  */
  public static get = SingletonHelper.createFactory(() => new FlashlightLiveManager());

  private hasSubscribe: boolean = false;

  private mCameraManager = camera.getCameraManager(GlobalContext.getContext());

  /**
   * 初始化
   *
   */
  init(): void {
    if(!SystemUICcmConfig.instance.isEnabledLive2) {
      return;
    }
    log.showInfo('on init flashlight')
    // 手电筒打开关闭
    EvtBus.on(FlashlightLiveEvent, this.onFlashlightChange)
    if (this.mCameraManager.getTorchMode() === TORCH_MODE_ON) {
      this.publishFlashLight();
    } else {
      this.cancelFlashlightLive();
    }
  }

  private onFlashlightChange = (event: FlashlightLiveEvent): void =>  {
    log.showInfo(`onFlashlightChange status:${event.isOn}`)
    if (event.isOn) {
      this.publishFlashLight();
    } else {
      //手电筒关闭，找到手电筒实况并删除。
      this.cancelFlashlightLive();
    }
  }

  private cancelFlashlightLive() {
    if (this.mCameraManager.getTorchMode() !== TORCH_MODE_OFF) {
      return;
    }
    const ntfMap = NotificationDataManager.instance.ntfMap;
    let flashlightNtf: NotificationBase[] = Array.from(ntfMap.values()).filter((ntf) => {
      return ntf.isLiveView() && ntf.isFlashLight()
    });
    if (flashlightNtf.length) {
      NotificationDataManager.instance.removeLiveView(flashlightNtf);
    }
  }

  private async getRawFilePixelMap(rawImagePath: string): Promise<image.PixelMap | undefined> {
    let pixelMap: image.PixelMap | undefined = undefined;
    try {
      let context: context.Context = GlobalContext.getContext() as context.Context;
      let array = context.resourceManager.getMediaByNameSync(rawImagePath);
      let res: image.ImageSource = image.createImageSource(array.buffer);
      if (!res) {
        log.showError(`setIcon failed. no resourceManager`);
      } else {
        pixelMap = await res.createPixelMap({
          desiredSize: {
            width: vp2px(40),
            height: vp2px(40)
          }
        });
        PixelMapUtil.addName(pixelMap, `flashlight_setIcon_${rawImagePath}}`);
        res.release();
        log.showInfo('set flashlight Icon success');
      }
    } catch (err) {
      log.showError(`set flashlight Icon failed: ${err}`);
    };
    return pixelMap;
  }

  private subscribeLiveView(): void {
    let systemLiveViewSubscriber: notificationManager.SystemLiveViewSubscriber = {
      onResponse: this.onResponseCallback
    };
    // 订阅系统实况窗(按钮)
    notificationManager.subscribeSystemLiveView(systemLiveViewSubscriber);
    this.hasSubscribe = true;
  }

  // 手电筒按钮回调(用户点击按钮，会返回这个回调，业务自己决定如何处理)
  private onResponseCallback = (id: number, option: notificationManager.ButtonOptions): void => {
    log.showInfo('response callback: ' + option.buttonName + 'notificationId:' + id);
    const mCameraManager = camera.getCameraManager(GlobalContext.getInstance().getObject('desktopContext') as featureAbility.Context);
    if (option.buttonName === Constants.BTN_NAME) {
      // 手电筒关闭按钮
      try {
        mCameraManager?.setTorchMode(0);
      } catch (err) {
        log.showError(`setTorchMode error:${err.message}`);
      }
    };
  };

  // 发布手电筒
  private async publishFlashLight(): Promise<void> {
    try {
      if (!this.hasSubscribe) {
        this.subscribeLiveView();
      }
      log.showInfo(`publishNtf start`);
      const ntfTitle = ResourceVm.instance.getString($r('app.string.control_center_complex_toggle_flashlight_title'));
      const capsuleTitle = ResourceVm.instance.getString($r('app.string.flash_light_open_accessible'));
      const content = ResourceVm.instance.getString($r('app.string.flashlight_on_ntf_content'));
      // 无障碍按钮
      const closeText = ResourceVm.instance.getString($r('app.string.access_close'));
      const btnText = ResourceVm.instance.getString($r('app.string.cc_accessibility_str_common_button_str'), closeText);
      const smallIcon = await this.getRawFilePixelMap(Constants.APP_ICON);
      if (!smallIcon) {
        log.showInfo('publish Ntf return: no icon');
        return;
      }
      const flashLightNtfRequest: notificationManager.NotificationRequest = {
        notificationSlotType: notificationManager.SlotType.LIVE_VIEW,
        id: Constants.NTF_ID,
        smallIcon: smallIcon,
        isRemoveAllowed: false,
        content: {
          notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW,
          systemLiveView: {
            typeCode: SysTypeCode.FLASH_LIGHT,
            liveViewType: LiveType.NORMAL as number,
            title: ntfTitle,
            text: content,
            cardButtons: [{
              name: Constants.BTN_NAME,
              iconResource: $r('app.media.ic_flashlight_button_icon'),
              text: btnText,
              hidePanel: false,
            }],
            capsule: {
              title: capsuleTitle,
              icon: smallIcon,
              backgroundColor: '#828FD2'
            }
          }
        },
        extraInfo: {
          isMute: true,
          openharmony_button_accessibility_text: [closeText],
          openharmony_customer_accessibility_text: ntfTitle
        }
      };
      await notificationManager.publish(flashLightNtfRequest);
      smallIcon?.release();
      log.showInfo('publishflashLightNtf success');
    } catch (err) {
      log.showInfo(`publish fail: ${JSON.stringify(err)}`);
    }
  }
}