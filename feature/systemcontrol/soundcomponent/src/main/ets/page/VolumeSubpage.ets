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

import {
  SliderButtonComponent,
  SliderOperation
} from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonComponent';
import {
  SliderButtonAnimViewData,
  SliderButtonViewData,
  SliderIconViewData,
  SubPageTransEffectData
} from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonViewData';
import { soundSubPageController } from '../controller/SoundSubPageLayoutController';
import { VolumeButtonViewModel } from '../controller/VolumeButtonViewModel';
import { BLEHeadsetPanel } from './component/BLEHeadsetPanel';

const SUBPAGE_LOTTIE_NAME: string = 'volume_subpage_lottie';

@Component
export default struct VolumeSubpage {
  private geometryTag: string = 'volume';
  private transEffectData: SubPageTransEffectData = new SubPageTransEffectData();
  // 音量条静态数据
  private viewData: SliderButtonViewData = new SliderButtonViewData(true);
  private isLongSliderButton: boolean = false;
  @Consume flexDirection: FlexDirection;
  // 音量条动效viewDate
  @Provide animViewData: SliderButtonAnimViewData = new SliderButtonAnimViewData();
  // lottie动效viewDate
  private iconViewData: SliderIconViewData = new SliderIconViewData(SUBPAGE_LOTTIE_NAME);
  // viewModel
  private viewModel: VolumeButtonViewModel =
    new VolumeButtonViewModel(this.viewData, this.animViewData, this.iconViewData, 'VolumeSubpage');
  @StorageLink('needReleaseToggleIcon') @Watch('updateLottieAnimMode') needReleaseToggleIcon: boolean = false;
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
      this.viewModel.onCanvasReady();
    },
    goSettingClick: () => {
      soundSubPageController.goVolumeSetting();
    },
    getAccessibility: (type: string) => {
      return this.viewModel.getAccessibility(type);
    },
    onKeyPreAction: (event: KeyEvent) => {
      return this.viewModel.onKeyPreAction(event)
    }
  };

  aboutToAppear(): void {
    if (this.isLongSliderButton) {
      this.viewData.setLargeFoldSliderButtonViewData(true);
    }
    this.viewModel.aboutToAppear();
    this.viewModel.executeSubpageAnim(true);
    this.geometryTag += (soundSubPageController.isHorizontal() ? '' : '_isVertical');
  }

  aboutToDisappear(): void {
    this.viewModel.aboutToDisappear();
  }

  updateLottieAnimMode(): void {
    if (this.needReleaseToggleIcon) {
      this.viewModel.getLottieAnimMode().onCanvasDisappear();
    } else {
      this.viewModel.getLottieAnimMode().onCanvasReady();
    }
  }

  build() {
    Flex({
      direction: this.flexDirection,
      alignItems: this.flexDirection === FlexDirection.Row ? ItemAlign.Start : ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      SliderButtonComponent({
        geometryTag: this.geometryTag,
        isExpand: true,
        isCanvasRotate: true,
        viewData: this.viewData,
        iconViewData: this.iconViewData,
        sliderOperation: $brightnessOperation,
        transEffectData: this.transEffectData
      })
      // 音频卡片布局
      BLEHeadsetPanel({ viewData: this.viewData })
    }.hitTestBehavior(HitTestMode.None)
  }
}