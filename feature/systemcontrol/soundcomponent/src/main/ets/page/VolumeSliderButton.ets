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
import {
  SliderButtonAnimViewData,
  SliderButtonViewData,
  SliderIconViewData
} from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonViewData';

import { VolumeButtonViewModel } from '../controller/VolumeButtonViewModel';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const ICON_LOTTIE_NAME: string = 'volume_icon_lottie';
@Component
export default struct VolumeSliderButton {
  public isEditMode: boolean = false;
  public isHorizontal: boolean = true;
  private geometryTag: string = 'volume';
    // 音量条视效viewDate
  private viewData: SliderButtonViewData = new SliderButtonViewData();
  @Prop isSingleFoldStyle: boolean;
  @Prop isLargeFoldStyle: boolean;
  private volumeButtonTag: string = this.getVolumeButtonTag();
  private isLandscape: boolean = AppStorage.get<boolean>('isLandscape') ?? false;
  // 音量条动效viewDate
  @Provide animViewData: SliderButtonAnimViewData = new SliderButtonAnimViewData();
  // lottie动效viewDate
  private iconViewData: SliderIconViewData = new SliderIconViewData(ICON_LOTTIE_NAME + '_' + this.volumeButtonTag);
  // viewModel
  private viewModel: VolumeButtonViewModel =
    new VolumeButtonViewModel(this.viewData, this.animViewData, this.iconViewData, this.volumeButtonTag);
  @StorageLink('currColorMode') @Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  @StorageLink('needReleaseToggleIcon') @Watch('updateLottieAnimMode') needReleaseToggleIcon: boolean = false;
  @State volumeOperation: SliderOperation = {
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
    handleOnHover: (isHover: boolean) => {
      this.viewModel.handleOnHover(isHover);
    },
    onTouchEvent: (event: TouchEvent) => {
      this.viewModel.onTouchEvent(event);
    },
    onCanvasReady: () => {
      this.viewModel.onCanvasReady();
    },
    getAccessibility: (type: string) => {
      return this.viewModel.getAccessibility(type);
    },
    onKeyPreAction: (event: KeyEvent) => {
      return this.viewModel.onKeyPreAction(event)
    }
  };

  private updateViewData(): void {
    let needUpdateTag: boolean = false;
    if (!this.isHorizontal) {
      this.viewData.updateVerticalStyle();
      this.volumeButtonTag += '_isVertical';
      needUpdateTag = true;
    }
    if (this.isEditMode) {
      this.volumeButtonTag += '_inEdit';
      needUpdateTag = true;
    }
    if (needUpdateTag) {
      this.iconViewData.lottieName = this.volumeButtonTag;
      this.viewModel.updateTag(this.volumeButtonTag);
    }
  }

  aboutToAppear(): void {
    this.updateViewData();
    if (this.isSingleFoldStyle) {
      this.viewData.setSingleFoldSliderButtonViewData();
    } else if (this.isLargeFoldStyle) {
      this.viewData.setLargeFoldSliderButtonViewData();
    }
    this.viewModel.aboutToAppear();
  }

  aboutToDisappear(): void {
    this.viewModel.aboutToDisappear();
    this.viewModel.getLottieAnimMode().onCanvasDisappear();
  }

  onColorModeChange() {
    this.viewModel.onColorModeChange(this.currColorMode);
  }

  getVolumeButtonTag(): string {
    if (this.isSingleFoldStyle) {
      return 'VolumeButtonSingleFold';
    } else if (this.isLargeFoldStyle) {
      return 'VolumeButtonLargeFold';
    }
    return AppStorage.get<boolean>('isLandscape') ?
      'VolumeButtonLandscape' : 'VolumeButtonPortrait';
  }

  updateLottieAnimMode(): void {
    if (this.needReleaseToggleIcon) {
      this.viewModel.getLottieAnimMode().onCanvasDisappear();
    } else {
      this.viewModel.getLottieAnimMode().onCanvasReady();
    }
  }

  build() {
    SliderButtonComponent({
      geometryTag: this.geometryTag + (this.isEditMode ? '_inEdit' : '') + (this.isHorizontal ? '' : '_isVertical'),
      isExpand: false,
      isCanvasRotate: true,
      viewData: this.viewData,
      iconViewData: this.iconViewData,
      sliderOperation: $volumeOperation
    })
  }
}