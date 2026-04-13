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
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { NavDestinationBuilderInterface, NavParam } from '../../../formcenter/interfaces/NavDestinationBuilderInterface';
import GridFormTileLayoutStyle from './GridFormTileLayoutStyle';

const TAG = 'FormTileScrollLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FormTileScrollLayoutWrapper implements NavDestinationBuilderInterface {
  public buildView(): WrappedBuilder<NavParam[]> {
    return wrapBuilder(navTileLayoutBuilder);
  }
}

@Builder
function navTileLayoutBuilder(param: NavParam) {
  FormTileScrollLayout({
    mFormList: param.cardList,
  })
}

@Component
export default struct FormTileScrollLayout {
  private isCardExceedLimit: boolean = false;
  private mFormList: CardItemInfo[] = [];
  @Consume mNavFocusable: boolean;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear show forms number:${this.mFormList.length} `);
  }

  build() {
    NavDestination() {
      GridFormTileLayoutStyle({
        mFormList: this.mFormList,
        isCardExceedLimit: this.isCardExceedLimit
      })
    }
    .focusable(this.mNavFocusable)
    .backgroundColor(Color.Transparent)
    .hideTitleBar(true)
    .width('100%')
    .height('100%')
  }
}