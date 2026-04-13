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

import { Log } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { ColorType, MainColor } from '../models/MainColor';
import { BrightnessOptionUtils } from '../utils/BrightnessOptionUtils';
import FloatingButton from './FloatingButton';
import { sFontScaleUtil } from '../../common/utils/FontScaleUtil';
import { ScreenLockCutOutUtil } from '../../common/utils/ScreenLockCutOutUtil';
const TAG: string = 'MediumButton';

@Component
export default struct MediumButton {
  @Prop showGuide: boolean;
  @Prop blurRadius: number = 0;
  @Prop animating: boolean = false;
  @Consume mainColor: MainColor;
  // private fgBrightness: BrightnessOptions = BrightnessOptionUtils.foregroundSecondaryDarkOption;
  // private bgBrightness: BrightnessOptions = BrightnessOptionUtils.backgroundSevenDarkOption;
  private fgBrightness: BackgroundBrightnessOptions = BrightnessOptionUtils.foregroundSecondaryDarkOption;
  private bgBrightness: BackgroundBrightnessOptions = BrightnessOptionUtils.backgroundSevenDarkOption;
  @Prop bgColor: ResourceColor = '#33FFFFFF';
  @Prop text: Resource;
  onButtonClick?: () => void;
  @State private isPressed: boolean = false;

  aboutToAppear(): void {
    if (this.mainColor.colorType === ColorType.LIGHT) {
      this.fgBrightness = BrightnessOptionUtils.foregroundSecondaryOption;
      this.bgBrightness = BrightnessOptionUtils.backgroundSixOption;
    }
  }

  @Builder
  GuideButton() {
    Button({ type: ButtonType.Capsule }) {
      Text(this.text)
        .fontSize($r('sys.float.ohos_id_text_size_button1'))
        .minFontScale(sFontScaleUtil.minFontSize)
        .maxFontScale(sFontScaleUtil.maxFontSize)
        .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
        .textAlign(TextAlign.Center)
        .opacity(0.9)
        .draggable(false)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .accessibilityLevel('yes')
    .accessibilityGroup(true)
    .accessibilityText(ResUtils.getInnerString(this.text))
    .accessibilityDescription(ResUtils.getInnerString($r('app.string.widgets_two_click_accessible')))
    .id(TAG + '_GuideButton')
    .renderGroup(this.animating)
    .backgroundColor('#33FFFFFF')
    .useEffect(true)
    .height('32vp')
    .padding({ left: '5vp', right: '5vp' })
    .constraintSize({ minWidth: '76vp', maxWidth: ScreenLockCutOutUtil.buttonMaxLength + 'vp' })
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        this.isPressed = true;
      } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
        this.isPressed = false;
      }
    })
    .onMouse((event: MouseEvent) => {
      if (event.action === MouseAction.Press) {
        this.isPressed = true;
      } else if (event.action === MouseAction.Release) {
        this.isPressed = false;
      }
    })
    .onClick((_event: ClickEvent) => {
      Log.info(TAG, 'onClick');
      this.onButtonClick && this.onButtonClick();
    })
    .responseRegion({
      x: 0,
      y: this.text ? -4 : 0,
      width: '100%',
      height: this.text ? '125%' : '100%'
    })
  }

  @Builder
  EditButton() {
    FloatingButton({
      text: this.text,
      callback: this.onButtonClick,
      isEnabled: true,
      isHighlighted: false,
      buttonType: ButtonType.Capsule,
    })
      .blur(this.blurRadius, undefined, { disableSystemAdaptation: true })
  }

  @Builder
  ApplyButton() {
    Button({ type: ButtonType.Capsule }) {
      Text(this.text)
        .draggable(false)
        .fontSize($r('sys.float.ohos_id_text_size_button1'))
        .minFontScale(sFontScaleUtil.minFontSize)
        .maxFontScale(sFontScaleUtil.maxFontSize)
        .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .opacity(0.9)
        .margin({top: 1})
    }
    .id(TAG + '_ApplyButton')
    .blur(this.blurRadius, undefined, { disableSystemAdaptation: true })
    .backgroundColor($r('sys.color.ohos_id_color_emphasize'))
    .align(Alignment.Center)
    .height('32vp')
    .padding({ left: '5vp', right: '5vp' })
    .constraintSize({ minWidth: '76vp', maxWidth: ScreenLockCutOutUtil.buttonMaxLength + 'vp' })
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        this.isPressed = true;
      } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
        this.isPressed = false;
      }
    })
    .onMouse((event: MouseEvent) => {
      if (event.action === MouseAction.Press) {
        this.isPressed = true;
      } else if (event.action === MouseAction.Release) {
        this.isPressed = false;
      }
    })
    .onClick((_event: ClickEvent) => {
      Log.info(TAG, 'onClick');
      this.onButtonClick && this.onButtonClick();
    })
    .responseRegion({
      x: 0,
      y: this.text ? -4 : 0,
      width: '100%',
      height: this.text ? '125%' : '100%'
    })
  }

  build() {
    if (this.bgColor !== '#33FFFFFF') {
      this.ApplyButton()
    } else if (this.showGuide) {
      this.GuideButton()
    } else {
      this.EditButton()
    }
  }
}
