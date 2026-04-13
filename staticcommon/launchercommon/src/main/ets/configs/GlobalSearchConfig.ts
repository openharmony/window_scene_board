/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

const globalSearchConfig: ISearchConfig = {
  indexName: 'sysApp',
  abilityName: 'abilityName',
  appName: 'appName',
  bundleName: 'bundleName',
  contentType: 'contentType',
  icon: 'icon',
  identifier: 'identifier',
  lastClickTime: 'lastClickTime',
  locationId: 'lcationId',
  match: 'match',
  term: 'term',
  outFieldNames: ['abilityName', 'appName', 'bundleName', 'contentType', 'icon', 'identifier', 'lastClickTime', 'lcationId'],
};

export default globalSearchConfig;

export interface ISearchConfig {
  indexName: string,
  abilityName: string,
  appName: string,
  bundleName: string,
  contentType: string,
  icon: string,
  identifier: string,
  lastClickTime: string,
  locationId: string,
  match: string,
  term: string,
  outFieldNames: string[]
}