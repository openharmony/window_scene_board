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

import { GlassLayoutManager } from '../../common/manager/GlassLayoutManager';
import { ControlCenterConstants } from '../components/constants/ControlCenterConstants';
import BlueToothComponent from '../components/mediacontrols/BlueToothComponent';
import VisionAdjustmentComponent from '../components/mediacontrols/VisionAdjustmentComponent';
import WifiComponent from '../components/mediacontrols/WifiComponent';
import VolumeControlComponent from './../components/systemcontrols/VolumeControlComponent';
import { calculateSize } from '../components/constants/WifiConstants';
import ScreenShotComponent from '../components/systemcontrols/ScreenShotComponent';
import { CastPhoneComponent } from '../components/systemcontrols/CastPhoneComponent';
import { PowerSaveModeComponent } from '../components/systemcontrols/PowerSaveModeComponent';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';
import BrightnessControlComponent from '../components/systemcontrols/BrightnessControlComponent';

const TAG = 'ControlCenterMainPage';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export default struct ControlCenterMainPage {
  @State visible: boolean = true;
  @Provide windowSize: SizeOptions = {
    width: GlassLayoutManager.getInstance().getScreenWidthPx(),
    height: GlassLayoutManager.getInstance().getScreenHeightPx()
  }

  private onClose(): void {
    GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_CONTROL);
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }

  build() {
    Stack() {
      Column()
        .width(ControlCenterConstants.FULL_SIZE)
        .height(ControlCenterConstants.FULL_SIZE)
        .backgroundBlurStyle(BlurStyle.Thick, {
          scale: 0.7,
          blurOptions: {
            grayscale: [40, 40]
          },
          colorMode: ThemeColorMode.DARK
        })
        .gesture(
          GestureGroup(GestureMode.Exclusive,
            TapGesture()
              .onAction(() => {
                this.onClose();
              }),
            PanGesture()
          )
        )

      Column() {
        // 控制中心第一行胶囊 椭圆形胶囊
        Row() {
          WifiComponent();
          VisionAdjustmentComponent({});
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        // 控制中心第二行胶囊 圆形胶囊
        Row() {
          BlueToothComponent()
          CastPhoneComponent()
          ScreenShotComponent()
          PowerSaveModeComponent()
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          BrightnessControlComponent();
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .height(calculateSize(this.windowSize.height as number, ControlCenterConstants.SLIDER_HEIGHT_SCALE))

        Row() {
          VolumeControlComponent();
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .height(calculateSize(this.windowSize.height as number, ControlCenterConstants.SLIDER_HEIGHT_SCALE))
      }
      .height(calculateSize(this.windowSize.height as number, ControlCenterConstants.BANNER_HEIGHT_SCALE))
      .width(calculateSize(this.windowSize.height as number, ControlCenterConstants.BANNER_WIDTH_SCALE))
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .alignContent(Alignment.Center)
    .width(ControlCenterConstants.FULL_SIZE)
    .height(ControlCenterConstants.FULL_SIZE)
  }
}