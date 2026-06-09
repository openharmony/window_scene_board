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
import AppListIndexerTemplate
  from '@ohos/managementcomponent/src/main/ets/com/ohos/view/component/AppListIndexerTemplate'
import { NavRouterComponents } from './ntfAndStatusBarCompontents'

interface AppListLoadInfo {
  isAppListLoaded: boolean;
}

/**
 * '通知和状态栏'页面应用列表组件
 * @param params 列表参数
 */
@Builder
export function navRouter($$: AppListLoadInfo) {
  AppListIndexerTemplate({ headerBuilder: routerComponents, isAppListLoaded: $$.isAppListLoaded })
    .height('100%')
    .width('100%')
}

/**
 * '通知和状态栏'导航栏组件
 */
@Builder
function routerComponents() {
  NavRouterComponents()
}