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

import { ColorType, MainColor } from '../models/MainColor';
import { BrightnessOptionUtils } from '../utils/BrightnessOptionUtils';
import { Constants } from '../utils/Contants';
import { sFontScaleUtil } from '../../common/utils/FontScaleUtil';
import { ScreenLockCutOutUtil } from '../../common/utils/ScreenLockCutOutUtil';

@Component
export default struct FloatingButton {
  @Prop image: Resource;
  callback?: () => void;
  text?: Resource;
  isMinorIcon: boolean = false;
  private buttonWidth: number = 76;
  private buttonHeight: number = 32;
  private imageWidth: number = 20;
  private edgeAntialias: number = 0;
  // private fgBrightness: BrightnessOptions = BrightnessOptionUtils.foregroundSecondaryDarkOption;
  // private bgBrightness: BrightnessOptions = BrightnessOptionUtils.backgroundSevenDarkOption;
  private fgBrightness: BackgroundBrightnessOptions = BrightnessOptionUtils.foregroundSecondaryDarkOption;
  private bgBrightness: BackgroundBrightnessOptions = BrightnessOptionUtils.backgroundSevenDarkOption;
  @Consume mainColor: MainColor;
  @Prop isEnabled: boolean;
  @Prop isHighlighted: boolean;
  @Prop buttonType: ButtonType;
  @Prop isPadBottomStyle: boolean;

  aboutToAppear(): void {
    if (this.mainColor.colorType === ColorType.LIGHT) {
      this.fgBrightness = BrightnessOptionUtils.foregroundSecondaryOption;
      this.bgBrightness = BrightnessOptionUtils.backgroundSixOption;
    }
  }

  @Styles
  blurAndShadowStyle() {
    .backgroundEffect({
      policy: 1,
      radius: Constants.BLUR_RADIUS,
    }, { disableSystemAdaptation: true })
    .shadow({
      radius: Constants.SHADOW_RADIUS,
      color: Constants.PANE_SHADOW_COLOR,
      offsetY: Constants.FLOAT_BTN_SHADOW_OFFSETY,
    })
  }

  build() {
    Row() {
      Button() {
        Stack() {
          if (this.text) {
            Text(this.text)
              .draggable(false)
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .minFontScale(sFontScaleUtil.minFontSize)
              .maxFontScale(sFontScaleUtil.maxFontSize)
              .foregroundColor('#FFFFFFFF')
              // .foregroundBrightness(this.fgBrightness)
              .backgroundBrightness(this.fgBrightness)
              .margin({top: 1})
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

          }
        }
      }
      .type(this.buttonType)
      .stateEffect(false)
      .size({
        height: this.buttonHeight,
      })
      .padding({ left: '5vp', right: '5vp' })
      .constraintSize({ minWidth: '76vp', maxWidth: ScreenLockCutOutUtil.buttonMaxLength + 'vp' })
      .align(Alignment.Center)
      .backgroundColor('#FFFFFFFF')
      // .backgroundBrightnessInternal(this.bgBrightness)
      .backgroundBrightness(this.bgBrightness)
      .enabled(this.isEnabled)
      .onClick((_event?: ClickEvent) => {
        this.callback && this.callback();
      })
      .responseRegion({
        x: 0,
        y: this.text ? -4 : 0,
        width: '100%',
        height: this.text ? '125%' : '100%'
      })
    }
    .size({
      height: this.buttonHeight,
    })
    .constraintSize({ minWidth: '76vp' })
    .borderRadius(16)
    .blurAndShadowStyle()
  }
}