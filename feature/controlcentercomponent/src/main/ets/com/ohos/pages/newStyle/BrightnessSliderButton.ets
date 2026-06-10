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

import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  SliderButtonComponent,
  SliderOperation
} from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonComponent';

import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  SliderButtonAnimViewData,
  SliderButtonViewData,
  SliderIconViewData
} from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonViewData';
import { BrightnessButtonViewModel } from '../../viewModel/BrightnessButtonViewModel';

const ICON_LOTTIE_NAME: string = 'brightness_icon_lottie'

@Component
export default struct BrightnessSliderButton {
  public isEditMode: boolean = false;
  public isHorizontal: boolean = true;
  private geometryTag: string = 'brightness';
  // 亮度条视效viewDate
  private viewData: SliderButtonViewData = new SliderButtonViewData(false, true);
  private isLandscape: boolean = AppStorage.get<boolean>('isLandscape') ?? false;
  // 亮度条动效viewDate
  @Provide animViewData: SliderButtonAnimViewData = new SliderButtonAnimViewData();
  private brightnessButtonTag: string = AppStorage.get<boolean>('isLandscape') ?
    'brightnessButtonLandscape' : 'brightnessButtonPortrait';
  // iconViewDate
  private iconViewData: SliderIconViewData = new SliderIconViewData(ICON_LOTTIE_NAME + '_' + this.brightnessButtonTag);
  private isSingleFoldStyle: boolean = false;
  private isLongSliderButton: boolean = false;
  // viewModel
  private viewModel: BrightnessButtonViewModel =
    new BrightnessButtonViewModel(this.viewData, this.animViewData, this.iconViewData, 'BrightnessButton');
  @StorageLink('BrightnessController_lottieDataReady') @Watch('lottieDataReady') isLottieDataReady: boolean = false;
  @StorageLink('needReleaseToggleIcon') @Watch('updateLottieAnimMode') needReleaseToggleIcon: boolean = false;
  @StorageLink('BrightnessValue') @Watch('onPhysicsValueChanged') physicsValue: number = 0;
  @StorageLink('currColorMode')@Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
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
    onLongPressAction: (event: GestureEvent) => {
      if (this.isSingleFoldStyle) {
        return;
      }
      this.viewModel.onLongPressAction(event, this.isHorizontal);
    },
    onTouchEvent: (event: TouchEvent) => {
      this.viewModel.onTouchEvent(event);
    },
    handleOnHover: (isHover: boolean) => {
      this.viewModel.handleOnHover(isHover);
    },
    onCanvasReady: () => {
      this.viewModel.getLottieAnimMode().onCanvasReady();
    },
    getAccessibility: (type: string) => {
      return this.viewModel.getAccessibility(type);
    },
    onKeyPreAction: (event: KeyEvent) => {
      return this.viewModel.onKeyPreAction(event)
    }
  };

  private updateViewData(): void {
    if (this.isEditMode) {
      this.iconViewData.lottieName += '_inEdit';
    }
    if (!this.isHorizontal) {
      this.viewData.updateVerticalStyle();
    }
  }

  aboutToAppear(): void {
    this.updateViewData();
    this.animViewData.useLottieData = this.isLottieDataReady;
    if (this.isSingleFoldStyle) {
      this.viewData.setSingleFoldSliderButtonViewData();
    } else if (this.isLongSliderButton) {
      this.viewData.setLargeFoldSliderButtonViewData();
    }
    this.viewModel.aboutToAppear();
  }

  lottieDataReady(): void {
    this.viewModel.loadLottieData(this.isLottieDataReady);
    this.animViewData.useLottieData = this.isLottieDataReady;
  }

  onPhysicsValueChanged() {
    this.viewModel.onPhysicsValueChange(this.physicsValue);
  }

  aboutToDisappear(): void {
    this.viewModel.aboutToDisappear();
    this.viewModel.getLottieAnimMode().onCanvasDisappear();
  }

  updateLottieAnimMode(): void {
    if (this.needReleaseToggleIcon) {
      this.viewModel.getLottieAnimMode().onCanvasDisappear();
    } else {
      this.viewModel.getLottieAnimMode().onCanvasReady();
    }
  }

  onColorModeChange() {
    this.viewModel.onColorModeChange(this.currColorMode);
  }

  build() {
    SliderButtonComponent({
      geometryTag: this.geometryTag + (this.isEditMode ? '_inEdit' : '') + (this.isHorizontal ? '' : '_isVertical'),
      isExpand: false,
      viewData: this.viewData,
      iconViewData: this.iconViewData,
      sliderOperation: $brightnessOperation
    })
  }
}