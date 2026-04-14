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
import lazy { NtfLiveViewSwitchPage } from './NtfLiveViewSwitchPage'
import lazy { StatusBarSetting } from './StatusBarSetting'
import lazy { NtfMoreSetting } from './NtfMoreSetting'
import lazy { NtfSearchPage } from './NtfSearchPage'
import lazy { NotificationMgmtView } from './NotificationMgmtView'
import lazy { MetaServiceMgmtView } from './MetaServiceMgmtView'
import lazy { NtfAndStatusBar } from './ntfAndStatusBar'
import lazy { PageConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants'


/**
 * 导航栏NavDestination组件映射
 *
 * @param name NavDestination页面名
 * @param param 参数
 */
@Builder
export function pageMap(name: string, param: ESObject) {
  if (name === PageConstants.STATUS_BAR_SETTING_NAME) {
    StatusBarSetting();
  } else if (name === PageConstants.NTF_MGMT_VIEW_NAME) {
    NotificationMgmtView({ appInfo: param?.item ?? param, pageInfos: param?.pageInfos })
  } else if (name === PageConstants.NTF_MORE_SETTING_NAME) {
    NtfMoreSetting();
  } else if (name === PageConstants.NTF_SEARCH_NAME) {
    NtfSearchPage();
  } else if (name === PageConstants.NTF_LIVE_VIEW_SWITCH_PAGE_NAME) {
    NtfLiveViewSwitchPage();
  } else if (name === PageConstants.META_SERVICE_MGMT_VIEW_NAME) {
    MetaServiceMgmtView({ appInfo: param?.item });
  } else if (name === PageConstants.NTF_AND_STATUS_BAR_NAME) {
    NtfAndStatusBar()
  }
}