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
import { describe } from '@ohos/hypium';
import { EditModeViewManagerTest } from './manager/EditModeViewManager.test';
import { EditModeViewEventTest } from './viewmodel/EditModeViewEvent.test';
import { EditModeViewAnimateTest } from './viewmodel/EditModeViewAnimate.test';
import { EditModeDockViewModelTest } from './viewmodel/EditModeDockViewModel.test';
import { IconEditViewModelTest } from './viewmodel/IconEditViewModel.test';
import { EditModeGridSwiperViewDataTest } from './data/EditModeGridSwiperViewData.test';
import { EditModeSingePageViewDataTest } from './data/EditModeSingePageViewData.test';
import { EditModeWallpaperViewDataTest } from './data/EditModeWallpaperViewData.test';
import { EditModeExtensionDataTest } from './data/EditModeExtensionData.test';
import { IconEditWantDataTest } from './data/IconEditWantData.test';
import { NavigationUtilTest } from './utils/NavigationUtil.test';
import { ThemeActiveManagerTest } from './utils/ThemeActiveManager.test';
import { GridRowUtilsTest } from './utils/GridRowUtilsTest.test';
import { EditModeUIExtensionViewModelTest } from './viewmodel/EditModeUIExtensionViewModel.test';
import { AppIconAnimateTest } from './viewmodel/AppIconAnimate.test';
import { AppIconViewEventTest } from './viewmodel/AppIconViewEvent.test';
import { OutIconCenterViewModelTest } from './viewmodel/OutIconCenterViewModel.test';
import { OuterButtonDockDataTest } from './data/OuterButtonDockData.test';
import { EditSearchComponentDataTest } from './viewmodel/EditSearchComponentData.test';

export default function PipelineDemoSuite() {
  describe("sceneboard_desktopedit", () => {
    AppIconAnimateTest();
    AppIconViewEventTest();
    EditModeViewManagerTest();
    EditModeViewEventTest();
    EditModeViewAnimateTest();
    EditModeDockViewModelTest();
    IconEditViewModelTest();
    EditModeGridSwiperViewDataTest();
    EditModeSingePageViewDataTest();
    EditModeWallpaperViewDataTest();
    EditModeExtensionDataTest();
    IconEditWantDataTest();
    NavigationUtilTest();
    ThemeActiveManagerTest();
    EditModeUIExtensionViewModelTest();
    GridRowUtilsTest();
    OutIconCenterViewModelTest();
    OuterButtonDockDataTest();
    EditSearchComponentDataTest();
  });
}