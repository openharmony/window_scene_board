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

import { AppItemInfo } from '@ohos/launchercommon';
import { SearchComponentParam } from '../view/atomicview/SearchComponent';
import { LazyDataSource } from '@ohos/launchercommon/Index';

export class SearchComponentStateData {
  @Track public searchValue: string = '';
}

export interface SearchComponentInterface {
  onAppear: () => void;
  onDisAppear: () => void;
  onFocus?: () => void;
  onBlur?: () => void;
  onSubmit: (value: string) => void;
  onChange: (value: string) => void;
  isShowResult: (searchValue: string) => boolean;
  init: (mSearchResultList: LazyDataSource<AppItemInfo>,
    mSearchComponentParam: SearchComponentParam,
    mController: SearchController,
    stateData: SearchComponentStateData,
    clearInputCallBack?: () => void) => void;
}