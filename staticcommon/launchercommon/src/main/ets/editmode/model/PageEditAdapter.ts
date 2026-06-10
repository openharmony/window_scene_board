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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { getBlankPageListType } from '../data/PageEditData';

const TAG: string = 'PageEditAdapter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class PageEditAdapter {
  private static instance: PageEditAdapter;
  // getBlankPageList设置默认返回值，避免空指针问题
  public getBlankPageList: getBlankPageListType = (): Map<number, boolean> => {
    return new Map<number, boolean>();
  };

  public static getInstance(): PageEditAdapter {
    if (!(PageEditAdapter.instance instanceof PageEditAdapter)) {
      log.showInfo('create multiSelectManager instance');
      PageEditAdapter.instance = new PageEditAdapter();
    }
    return PageEditAdapter.instance;
  }
}