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
import IconEditPage from '@ohos/desktopedit/src/main/ets/uiExtension/view/IconEditPage';
import { EditModeConstants } from '@ohos/desktopedit/src/main/ets/default/common/constants/EditModeConstants';
import { desktopEditPageViewModel } from '@ohos/phonebase/src/main/ets/desktopedit/viewmodel/DesktopEditPageViewModel';
import DesktopPreview from '@ohos/pagedesktop/src/main/ets/default/preview/DesktopPreview';
import { PreviewConstants } from '@ohos/pagedesktop/src/main/ets/default/preview/PreviewConstants';

let storage = LocalStorage.getShared();

@Entry(storage)
@Component
export default struct DesktopEditPage {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();

  aboutToAppear() {
    desktopEditPageViewModel.dealParms(this.pageInfos);
  }

  @Builder
  PageMap(name: string) {
    if (name === EditModeConstants.PATH_ICON) {
      IconEditPage()
    } else if (name === PreviewConstants.PREVIEW_PATH) {
      DesktopPreview()
    }
  }

  build() {
    Navigation(this.pageInfos) {
    }
    .id('desktop_edit_page_navigation')
    .hideTitleBar(true)
    .navDestination(this.PageMap)
    .mode(NavigationMode.Stack)
  }
}