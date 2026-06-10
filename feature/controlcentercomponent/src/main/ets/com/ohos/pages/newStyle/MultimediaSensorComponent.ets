/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { ConfigurationConstant } from '@kit.AbilityKit';
import { audio } from '@kit.AudioKit';
import mechanicManager from '@ohos.distributedHardware.mechanicManager';
import { LogDomain, Logger } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import StyleConfiguration, {
  ToggleLabelStyle
} from '@ohos/systemuicommon/src/main/ets/template/common/StyleConfiguration';
import {
  isAcousticEchoCancelerSupported,
  SOURCE_TYPE_LIVE
} from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubIsAcousticEchoCancelerSupported';
import {
  BLEND_MODE_SRC_IN,
  BLEND_MODE_SRC_OVER,
  LINEAR_GRADIENT_PROPORTION_PRIVACY_SENSOR
} from '../../common/Constants';
import { ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { sMultimediaSubPageLayoutController } from '../../controller/MultimediaSubPageLayoutController';
import { ControlCenterAnimationData } from '../../model/ControlCenterAnimationData';
import { PrivacySensorViewData } from '../../model/PrivacySensorViewData';
import { ControlCenterMultimediaType, PrivacySensorViewModel } from '../../viewModel/PrivacySensorViewModel';

const TAG: string = 'Ctrl.MultimediaSensorComponent';
const log: Logger = Logger.getLogHelper(LogDomain.CC);

@Component
export default struct MultimediaSensorComponent {
  private audioStreamManager: audio.AudioStreamManager | undefined = undefined;
  @State fontStyle: ToggleLabelStyle = StyleConfiguration.getToggleLabelStyle();
  @Consume privacySensorData: PrivacySensorViewData;
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  viewModel: PrivacySensorViewModel = PrivacySensorViewModel.getInstance(this.privacySensorData);
  @ObjectLink animationData: ControlCenterAnimationData;
  @StorageLink('controlCenterFontScale') controlCenterFontScale: number = 1;
  @StorageProp('currColorMode') @Watch('updateSmallIcon') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  @StorageProp('isLandscape') isLandscape: boolean = false;
  @State bracketKitSmallIcon: Resource = $r('app.media.ic_gimbal_control_small');
  @State soundEffectSmallIcon: Resource = $r('app.media.ic_sound_effect_small');
  @State videoEffectSmallIcon: Resource = $r('app.media.ic_video_effect_small');
  @State multimediaSensorWidth: Length = 0;

  aboutToAppear() {
    log.showInfo(TAG, 'aboutToAppear');
    this.audioStreamManager = audio.getAudioManager()?.getStreamManager();
    if (isAcousticEchoCancelerSupported(this.audioStreamManager, SOURCE_TYPE_LIVE)) {
      this.audioStreamManager.on('audioCapturerChange', this.viewModel.updateCapturerCallback);
    } else {
      this.audioStreamManager = undefined;
    }
    try {
      mechanicManager.on('attachStateChange', this.viewModel.attachStateChangeCallback);
    } catch (err) {
      log.showError(TAG, `attachStateChange err ${err}`);
    }
    this.updateSmallIcon();
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'aboutToDisappear');
    this.audioStreamManager?.off('audioCapturerChange');
    this.audioStreamManager = undefined;
    try {
      mechanicManager.off('attachStateChange');
    } catch (error) {
      log.showError(TAG, `mechanicManager off failed, error: ${error}`);
    }
  }

  build() {
    if (this.privacySensorData.multimediaSensorTypeArray.includes(true)) {
      Stack() {
        Row({ space: 4 }) {
          if (this.privacySensorData.multimediaSensorTypeArray[ControlCenterMultimediaType.BRACKET_KIT.valueOf()]) {
            Image(this.bracketKitSmallIcon).imageSizeStyle()
          }
          if (this.privacySensorData.multimediaSensorTypeArray[ControlCenterMultimediaType.SOUND_EFFECT.valueOf()]) {
            Image(this.soundEffectSmallIcon).imageSizeStyle()
          }
          if (this.privacySensorData.multimediaSensorTypeArray[ControlCenterMultimediaType.VIDEO_EFFECT.valueOf()]) {
            Image(this.videoEffectSmallIcon).imageSizeStyle()
          }
          Row({ space: 4 }) {
            if (this.privacySensorData.isShowText) {
              Row() {
                Text(this.viewModel.getMultimediaSensorText())
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
              .linearGradient(this.viewModel.isTextOverflow(this.viewModel.getMultimediaSensorText(),
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
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.multimediaSensorWidth = newValue.width;
        })
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .clickEffect({ level: ClickEffectLevel.LIGHT })
        .geometryTransition(this.privacySensorData.multimediaGeometryTransitionId[0],
          { follow: true })
        .onClick(() => {
          let availableList: number[] = [];
          this.privacySensorData.multimediaSensorTypeArray.forEach((value, index) => {
            if (value) {
              availableList.push(index);
            }
          })
          sMultimediaSubPageLayoutController.showWindow(availableList);
        })
        .accessibilityGroup(true)
        .accessibilityText(this.viewModel.getMultimediaSensorText())

        Row()
          .height('100%')
          .width(this.multimediaSensorWidth)
          .borderRadius($r('app.float.control_center_privacy_border_radius'))
          .visibility(Visibility.Hidden)
          .geometryTransition(this.privacySensorData.multimediaGeometryTransitionId[1],
            { follow: true })
        Row()
          .height('100%')
          .width(this.multimediaSensorWidth)
          .borderRadius($r('app.float.control_center_privacy_border_radius'))
          .visibility(Visibility.Hidden)
          .geometryTransition(this.privacySensorData.multimediaGeometryTransitionId[2],
            { follow: true })
      }
    }
  }

  @Styles
  imageSizeStyle() {
    .width(this.privacySensorData.privacySensorImgSize)
    .height(this.privacySensorData.privacySensorImgSize)
  }

  private updateSmallIcon(): void {
    log.showInfo(TAG, `currColorMode changed to ${this.currColorMode}`);
    if (this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.bracketKitSmallIcon = $r('app.media.ic_gimbal_control_small_dark');
      this.soundEffectSmallIcon = $r('app.media.ic_sound_effect_small_dark');
      this.videoEffectSmallIcon = $r('app.media.ic_video_effect_small_dark');
    } else {
      this.bracketKitSmallIcon = $r('app.media.ic_gimbal_control_small');
      this.soundEffectSmallIcon = $r('app.media.ic_sound_effect_small');
      this.videoEffectSmallIcon = $r('app.media.ic_video_effect_small');
    }
  }
}
