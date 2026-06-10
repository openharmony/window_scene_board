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

import { CallerInfo } from '@ohos/themeservicebase/Index'

export const OHOS_TEST_openharmony_APP: CallerInfo = {
  bundleName: 'com.ohos.thememanager',
  appIdentifier: '1173750081090759360',
  appId: 'com.ohos' +
    '.thememanager_BGpZXgzDm7D/DRjm7xC/KbWXXBrA6UMGWUdhK3WRj0UUX4Z0qF0sPckxGtn0HpXgoIvrBrQK4WR4eFQY5GW3c9bPMs7p2mMsu/rHZTfAZniVxh5aJMCsGSWsafENAlHqxw==',
  fingerprint: '9F74503084358713D4374185104E50F49EBA0864B38301E73D01B77654BDDFE0'
}

export namespace Illegal {
  export const bundleName: CallerInfo = {
    bundleName: 'com.ohos.thememanager_illegal',
    appIdentifier: '1173750081090759360',
    appId: 'com.ohos' +
      '.thememanager_BGpZXgzDm7D/DRjm7xC/KbWXXBrA6UMGWUdhK3WRj0UUX4Z0qF0sPckxGtn0HpXgoIvrBrQK4WR4eFQY5GW3c9bPMs7p2mMsu/rHZTfAZniVxh5aJMCsGSWsafENAlHqxw==',
    fingerprint: '9F74503084358713D4374185104E50F49EBA0864B38301E73D01B77654BDDFE0'
  }

  export const appIdentifier: CallerInfo = {
    bundleName: 'com.ohos.thememanager',
    appIdentifier: '1173750081090759360_illegal',
    appId: 'com.ohos' +
      '.thememanager_BGpZXgzDm7D/DRjm7xC/KbWXXBrA6UMGWUdhK3WRj0UUX4Z0qF0sPckxGtn0HpXgoIvrBrQK4WR4eFQY5GW3c9bPMs7p2mMsu/rHZTfAZniVxh5aJMCsGSWsafENAlHqxw==',
    fingerprint: '9F74503084358713D4374185104E50F49EBA0864B38301E73D01B77654BDDFE0'
  }

  export const appId: CallerInfo = {
    bundleName: 'com.ohos.thememanager',
    appIdentifier: '1173750081090759360',
    appId: 'com.ohos',
    fingerprint: '9F74503084358713D4374185104E50F49EBA0864B38301E73D01B77654BDDFE0'
  }

  export const fingerprint: CallerInfo = {
    bundleName: 'com.ohos.thememanager',
    appIdentifier: '1173750081090759360_illegal',
    appId: 'com.ohos' +
      '.thememanager_BGpZXgzDm7D/DRjm7xC/KbWXXBrA6UMGWUdhK3WRj0UUX4Z0qF0sPckxGtn0HpXgoIvrBrQK4WR4eFQY5GW3c9bPMs7p2mMsu/rHZTfAZniVxh5aJMCsGSWsafENAlHqxw==',
    fingerprint: '9F74503084358713D4374185104E50F49EBA0864B38301E73D01B77654BDDFE0__illegal'
  }
}
