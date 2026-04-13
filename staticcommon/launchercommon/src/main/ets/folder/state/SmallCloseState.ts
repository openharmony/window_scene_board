/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
 *
 * 小文件夹关闭态
 */

import { LogDomain, LogHelper } from '@ohos/basicutils';

import { BaseFolderState } from './BaseFolderState';

const TAG = 'SmallCloseState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class SmallCloseState extends BaseFolderState {
  constructor() {
    super();
  }

  /**
   * 小文件夹关闭态点击打开小文件夹
   *
   */
  public clickOpenSmallFolder(event: ClickEvent, folderId: string): void {
    log.showDebug('SmallCloseState clickOpenSmallFolder');
  }

  /**
   * 小文件夹关闭态点击关闭小文件夹
   *
   */
  public clickCloseSmallFolder(folderId: string): void {
    log.showDebug('SmallCloseState clickCloseSmallFolder');
  }
}

