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

const TAG: string = 'SubWindowPage';

@Entry
@Component
struct SubWindowPage {
  @Provide('subWindowPageInfos') subWindowPageInfos: NavPathStack = new NavPathStack();

  @Builder
  public PageMap(name: string) {
    // if (name === Constants.PHOTO_PICKER) {
      // PhotoPickerNav();
    // } else {
    // }
  }

  aboutToAppear(): void {
    // const params: SubWindowParams | undefined = SubWindowUtil.subWindowParams;
    // if (params) {
    //   this.subWindowPageInfos.pushPath({ name: params.nav, param: params }, false);
    // } else {
      // Log.error(TAG, 'aboutToAppear no params');
      // SubWindowUtil.destroySubWindow();
    // }
  }

  build() {
    Navigation(this.subWindowPageInfos) {
    }
    .hitTestBehavior(HitTestMode.None)
    .backgroundColor(Color.Transparent)
    .id('SubWindowPage')
    .hideTitleBar(true)
    .navDestination(this.PageMap)
    .hideNavBar(true)
    .mode(NavigationMode.Stack)
  }
}