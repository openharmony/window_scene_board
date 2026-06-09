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

import { SearchItemInfo } from '../remote/model/ThemeSearchInfo';

export class SearchCache {
  public locale: string = '';
  public versions: SearchVersion[] = [];

  constructor(locale: string, versions: SearchVersion[]) {
    this.locale = locale;
    this.versions = versions;
  }
}

export class SearchVersion {
  public id: string = '';
  public version: string = '';

  constructor(id: string, version: string) {
    this.id = id;
    this.version = version;
  }
}

export class SearchVersionExt {
  public readonly id: string;
  public version: string = '';
  public itemInfo: SearchItemInfo;

  constructor(id: string, itemInfo: SearchItemInfo) {
    this.id = id;
    this.itemInfo = itemInfo;
  }
}