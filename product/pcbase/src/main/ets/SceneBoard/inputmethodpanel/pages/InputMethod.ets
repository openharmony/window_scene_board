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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import ViewModel from '../viewmodel/InputMethodPanelViewModel';

const TAG = 'InputMethod';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const COMPONENT_ID_ICON = TAG + '_Image_icon';
const COMPONENT_ID_TITLE = TAG + '_Text_title';

@Component
export default struct InputMethod {
  inputMethodInfo: any = null;
  @State mIcon:string = '';
  @State mTitle:string = '';

  updateMethodList() {
    log.showInfo(`updateMethodList, mInputMethodList:${JSON.stringify(this.inputMethodInfo)}`);
    ViewModel.updateIcon(this.inputMethodInfo, this.iconLoadCallback.bind(this));
    ViewModel.updateTitle(this.inputMethodInfo, this.titleLoadCallback.bind(this));
  }

  iconLoadCallback(image: string) {
    log.showInfo(`image:${image}`);
    this.mIcon = image;
  }

  titleLoadCallback(title: string) {
    log.showInfo(`title:${title}`);
    this.mTitle = title;
  }

  buildLog(inputMethodInfo: any): boolean {
    log.showInfo(`inputMethodInfo:${JSON.stringify(inputMethodInfo)}`);
    return true;
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear, ${JSON.stringify(this.inputMethodInfo)}`);
    this.updateMethodList();
  }

  build() {
    Row() {
      if (this.buildLog(this.inputMethodInfo)) {}
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Image(this.mIcon).draggable(false)
          .id(COMPONENT_ID_ICON)
          .height('18vp')
          .width('18vp')

        Column().width('10vp')

        Text(this.mTitle).draggable(false)
          .id(COMPONENT_ID_TITLE)
          .fontSize('14vp')
      }
      .margin({ left: '35vp', right: '24vp'})
    }
    .height('40vp')
  }
}