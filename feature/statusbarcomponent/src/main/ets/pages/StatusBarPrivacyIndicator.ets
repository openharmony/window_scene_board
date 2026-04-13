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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import DeviceInfo from '@ohos.deviceInfo';
import { display, LengthMetrics } from '@kit.ArkUI';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { StatusBarMoveDownVmV1,
  StatusBarMoveDownVmV2 } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/StatusBarMoveDownVm';

const TAG = 'StatusBarPrivacyIndicator';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const productSeries: string = DeviceInfo.productSeries;
const IS_XYAO_PRODUCT: boolean = productSeries.includes('XYAO');

/**
 * 圆点尺寸接口
 */
export interface CircleSize {
  sizeFromBatterRight: number,
  width: number
}

/**
 * 获取圆点尺寸
 * @returns
 */
function getCircleSize(): CircleSize {
  if (productSeries.includes('DCO') || productSeries.includes('LYA') || productSeries.includes('ALT')) {
    return { sizeFromBatterRight: 0, width: 4 };
  } else if (productSeries.includes('XYAO')) {
    return { sizeFromBatterRight: 1, width: 5 };
  } else {
    return { sizeFromBatterRight: 0, width: 5 };
  }
}

/**
 * 状态栏背景
 */
@Component
export struct StatusBarPrivacyIndicator {
  private moveDownVmV2: StatusBarMoveDownVmV2 = StatusBarMoveDownVmV2.getInstance();
  @State private moveDownVmV1: StatusBarMoveDownVmV1 = StatusBarMoveDownVmV1.getInstance();
  private circleSize: CircleSize = getCircleSize();
  @Consume statusBarPaddingRight: string;
  @StorageProp('fakeLightIsShow') fakeLightIsShow: boolean | undefined = AppStorage.get<boolean>('fakeLightIsShow');
  @State checkTimerId: number = -1;
  @StorageProp('cacheMicroPhoneLightStatus') cacheMicroPhoneLightStatus: boolean | undefined =
    AppStorage.get<boolean>('cacheMicroPhoneLightStatus');
  @StorageProp('cacheCameraLightStatus') cacheCameraLightStatus: boolean | undefined =
    AppStorage.get<boolean>('cacheCameraLightStatus');

  aboutToAppear(): void {
    log.showInfo(`StatusBarPrivacyIndicator abouttoappear ${this.fakeLightIsShow} cacheMicroPhoneLightStatus ${this.cacheMicroPhoneLightStatus} .`);
  }

  aboutToDisappear(): void {
    log.showInfo(`StatusBarPrivacyIndicator aboutToDisappear.`);
  }

  build() {
    Stack() {
      if (this.fakeLightIsShow) {
        if (this.cacheMicroPhoneLightStatus) {
          Circle()
            .draggable(false)
            .width(this.circleSize.width)
            .height(this.circleSize.width)
            .fill($r('app.color.microphone_circle'))
            .zIndex(0)
            .id('statusbar_privacy_microphone_circle')
        }
        if (this.cacheCameraLightStatus) {
          Circle()
            .draggable(false)
            .width(this.circleSize.width)
            .height(this.circleSize.width)
            .fill($r('app.color.battery_component_pic_level_low_color'))
            .zIndex(0)
            .id('statusbar_privacy_camera_circle')
        }
      }
    }
    .height(this.circleSize.width)
    .width(this.circleSize.width)
    .position({
      end: new LengthMetrics(this.getMarginRight()),
      top: new LengthMetrics(this.getMarginTop()),
    })
  }

  private getMoveDownVm() {
    const isLiveV2 = SystemUICcmConfig.instance.isEnabledLive2;
    if (isLiveV2) {
      return this.moveDownVmV2;
    } else {
      return this.moveDownVmV1;
    }
  }

  private getMarginTop(): number {
    let top = this.getMoveDownVm().statusBarCenterY - this.circleSize.width / 2 + this.getMoveDownVm().curMoveDis;
    return top;
  }

  /**
   * 获取隐私指示器右侧外边距
   */
  private getMarginRight(): number {
    try {
      // 状态栏rightPadding
      let paddingRight = Number.parseFloat(this.statusBarPaddingRight.replace('vp', ''));
      // XYAO设备会额外多4vp
      if (IS_XYAO_PRODUCT && display.getDefaultDisplaySync().orientation === display.Orientation.PORTRAIT) {
        paddingRight += 4;
      }
      // 计算指示器显示位置
      const positionX = paddingRight - this.circleSize.sizeFromBatterRight - this.circleSize.width;
      return positionX;
    } catch (err) {
      log.showWarn(`getMMarginRight error: ${err?.code}, ${err?.message}`);
      return 0;
    }
  }
}