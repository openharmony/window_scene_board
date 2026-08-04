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

import {
  SliderButtonAnimViewData,
  SliderButtonViewData,
  SliderIconViewData
} from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonViewData';
import { BrightnessButtonViewModel } from '../../viewModel/BrightnessButtonViewModel';
import { BrightnessSharedViewData } from '../../viewModel/BrightnessViewModel';
import { BackgroundOpacity } from '../../model/BrightnessViewData';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  SliderButtonComponent,
  SliderOperation
} from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonComponent';
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { sBrightnessSubPageLayoutController } from '../../controller/BrightnessSubPageLayoutController';
import { ResUtils } from '@ohos/windowscene';

const TAG = 'Ctrl.BrightnessSubpageLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const SUBPAGE_LOTTIE_NAME: string = 'brightness_subpage_lottie'

@Component
export default struct BrightnessSubpageLayout {
  private geometryTag: string = 'brightness';
  // 亮度条视效viewDate
  private viewData: SliderButtonViewData = new SliderButtonViewData(true, true);
  private isLongSliderButton: boolean = false;
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  @Link contentHeight: number | string;
  @State backgroundOpacity: BackgroundOpacity =
    BrightnessSharedViewData.getInstance().getBackgroundOpacity();
  // 亮度条动效viewDate
  @Provide animViewData: SliderButtonAnimViewData = new SliderButtonAnimViewData();
  // iconViewDate
  private iconViewData: SliderIconViewData = new SliderIconViewData(SUBPAGE_LOTTIE_NAME);
  // viewModel
  private viewModel: BrightnessButtonViewModel =
    new BrightnessButtonViewModel(this.viewData, this.animViewData, this.iconViewData, 'BrightnessSubpage');
  @StorageLink('BrightnessController_lottieDataReady') @Watch('lottieDataReady') isLottieDataReady: boolean = false;
  @StorageLink('needReleaseToggleIcon') @Watch('updateLottieAnimMode') needReleaseToggleIcon: boolean = false;
  @StorageLink('BrightnessValue') @Watch('onPhysicsValueChanged') physicsValue: number = 0;
  @State brightnessOperation: SliderOperation = {
    onPanActionStart: (event: GestureEvent) => {
      this.viewModel.onPanActionStart(event);
    },
    onPanActionUpdate: (event: GestureEvent) => {
      this.viewModel.onPanActionUpdate(event);
    },
    onPanActionEnd: (event?: GestureEvent) => {
      this.viewModel.onPanActionEnd(event);
    },
    onTapAction: (event: GestureEvent) => {
      this.viewModel.onTapAction(event);
    },
    onCanvasReady: () => {
      this.viewModel.getLottieAnimMode().onCanvasReady();
    },
    goSettingClick: () => {
      sBrightnessSubPageLayoutController.goBrightnessSetting();
    },
    getAccessibility: (type: string) => {
      return this.viewModel.getAccessibility(type);
    },
    onKeyPreAction: (event: KeyEvent) => {
      return this.viewModel.onKeyPreAction(event)
    },
    onSwitchChange: (state: boolean): void => {
      return this.viewModel.onSwitchChange(state);
    }
  };

  lottieDataReady(): void {
    this.animViewData.useLottieData = false;
    this.animViewData.useSymbol = true;
    this.animViewData.sliderIcon = $r('sys.symbol.sun_max');
  }

  aboutToAppear(): void {
    this.animViewData.useLottieData = false;
    this.animViewData.useSymbol = true;
    this.animViewData.sliderIcon = $r('sys.symbol.sun_max');
    if (this.isLongSliderButton) {
      this.viewData.setLargeFoldSliderButtonViewData(true);
    }
    this.viewModel.aboutToAppear();
    this.viewData.moreSettingTopMargin =
      ResUtils.getConvertNumber($r('app.float.Control_center_subpage_toggle_more_setting_top_margin'));
    this.viewData.buttonHeight =
      ResUtils.getConvertNumber($r('app.float.Control_center_subpage_slider_toggle_button_height'));
    this.geometryTag += (sBrightnessSubPageLayoutController.isHorizontal() ? '' : '_isVertical');
  }

  updateLottieAnimMode(): void {
    if (this.needReleaseToggleIcon) {
      this.viewModel.getLottieAnimMode().onCanvasDisappear();
    } else {
      this.viewModel.getLottieAnimMode().onCanvasReady();
    }
  }

  onPhysicsValueChanged(): void {
    this.viewModel.onPhysicsValueChange(this.physicsValue);
  }

  aboutToDisappear(): void {
    this.viewModel.aboutToDisappear();
  }

  private backToMainPage(event?: TouchEvent) {
    if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
      log.showInfo(`BrightnessSubpageLayout touch event`)
      sBrightnessSubPageLayoutController.hideWindow();
    }
  }

  build() {
    Stack() {
      this.loadBlankStack()
      Stack() {
        this.loadBlankStack()
        SliderButtonComponent({
          geometryTag: this.geometryTag,
          isExpand: true,
          viewData: this.viewData,
          iconViewData: this.iconViewData,
          sliderOperation: $brightnessOperation,
          switchState: this.viewModel.getAutoBrightnessState()
        })
      }
      .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelWidth)
      .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageVerticalCenter ? '100%' : this.contentHeight)
      .margin(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelMargin)
    }
    .direction(Direction.Ltr)
    .width('100%')
    .height('100%')
    .alignContent(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelAlignment)
  }

  @Builder
  loadBlankStack() {
    Stack() {
    }.width('100%')
    .height('100%')
    .onTouch((event) => {
      this.backToMainPage(event);
    })
  }
}