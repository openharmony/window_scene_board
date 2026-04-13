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

import { LogDomain, Logger } from '@ohos/basicutils';
import StyleConfiguration, {
  ToggleLabelStyle
} from '@ohos/systemuicommon/src/main/ets/template/common/StyleConfiguration';
import {
  BLEND_MODE_SRC_IN,
  BLEND_MODE_SRC_OVER,
  LINEAR_GRADIENT_PROPORTION_PRIVACY_SENSOR
} from '../../common/Constants';
import { ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { sPrivacySubLayoutController } from '../../controller/PrivacySubPageLayoutController';
import { ControlCenterAnimationData } from '../../model/ControlCenterAnimationData';
import { PrivacySensorViewData } from '../../model/PrivacySensorViewData';
import { ControlCenterPrivacyType, PrivacySensorViewModel } from '../../viewModel/PrivacySensorViewModel';

const TAG: string = 'Ctrl.PrivacySensorComponent';
const log: Logger = Logger.getLogHelper(LogDomain.CC);

@Component
export default struct PrivacySensorComponent {
  @State fontStyle: ToggleLabelStyle = StyleConfiguration.getToggleLabelStyle();
  @Consume privacySensorData: PrivacySensorViewData;
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  viewModel: PrivacySensorViewModel = PrivacySensorViewModel.getInstance(this.privacySensorData);
  @ObjectLink animationData: ControlCenterAnimationData;
  @StorageLink('controlCenterFontScale') controlCenterFontScale: number = 1;

  aboutToAppear() {
    log.showInfo(TAG, 'aboutToAppear');
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'aboutToDisappear');
  }

  build() {
    Row({ space: 4 }) {
      if (this.privacySensorData.privacySensorTypeArray.includes(ControlCenterPrivacyType.CAMERA.valueOf())) {
        Image($r('app.media.privacy_camera')).imageSizeStyle()
      }
      if (this.privacySensorData.privacySensorTypeArray.includes(ControlCenterPrivacyType.MICROPHONE.valueOf())) {
        Image($r('app.media.privacy_microphone')).imageSizeStyle()
      }
      if (this.privacySensorData.privacySensorTypeArray.includes(ControlCenterPrivacyType.LOCATION.valueOf())) {
        Image($r('app.media.privacy_position')).imageSizeStyle()
      }
      Row({ space: 4 }) {
        if (this.privacySensorData.isShowText) {
          Row() {
            Text(this.privacySensorData.recentAppName)
              .fontSize(this.privacySensorData.privacySensorFontSize * this.controlCenterFontScale + 'vp')
              .lineHeight(this.privacySensorData.privacySensorLineHeight + 'vp')
              .fontColor(this.fontStyle.labelColor)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Clip })
              .wordBreak(WordBreak.BREAK_ALL)
              .constraintSize({
                maxWidth: this.privacySensorData.textMaxWidth
              })
              .blendMode(BLEND_MODE_SRC_IN, BlendApplyType.OFFSCREEN)
          }
          .linearGradient(this.viewModel.isTextOverflow(this.privacySensorData.recentAppName,
            this.privacySensorData.privacySensorFontSize * this.controlCenterFontScale + 'vp') ? {
            direction: GradientDirection.Right,
            colors: [
              [this.fontStyle.labelColor, 0],
              [this.fontStyle.labelColor, LINEAR_GRADIENT_PROPORTION_PRIVACY_SENSOR],
              ['rgba(0, 0, 0, 0)', 1]
            ]
          } : {
            colors: [[this.fontStyle.labelColor, 1]]
          })
          .blendMode(BLEND_MODE_SRC_OVER, BlendApplyType.OFFSCREEN)
        }

        Image($r('app.media.privacy_right_arrow'))
          .width(this.privacySensorData.privacySensorArrowWidth)
          .height(this.privacySensorData.privacySensorArrowHeight)
          .fillColor(this.fontStyle.labelColor)
          .rotate({ y: 1, angle: this.privacySensorData.isRTL ? 180 : 0 })
          .opacity(0.6)
      }
    }
    .backgroundColor($r('app.color.control_center_sensor_background'))
    .borderRadius($r('app.float.control_center_privacy_border_radius'))
    .padding({ left: 6, right: 6 })
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .visibility(this.privacySensorData.isApplicationInterview ? Visibility.Visible : Visibility.None)
    .clickEffect({ level: ClickEffectLevel.LIGHT })
    .onClick(() => {
      sPrivacySubLayoutController.showWindow();
    })
    .accessibilityGroup(true)
    .accessibilityText(this.viewModel.getPrivacySensorText(this.privacySensorData.recentAppName))
  }

  @Styles
  imageSizeStyle() {
    .width(this.privacySensorData.privacySensorImgSize)
    .height(this.privacySensorData.privacySensorImgSize)
  }
}
