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

import { AppItemInfo, CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { NavDestinationViewData } from '../../default/viewmodel/FormCenterObservedData';
import { FormCenterSplitViewStyle } from '../viewstyles/FormCenterSplitViewStyle';

// 卡片信息
export interface NavParam {
  cardList: CardItemInfo[];
  navDestinationViewData: NavDestinationViewData;
  name: string;
  destinationParam?: NavDestinationParam;
  appInfo?: AppItemInfo;
  style?: FormCenterSplitViewStyle,
}

export interface NavDestinationParam {
  themeId?: string;
}

export interface NavDestinationBuilderInterface {
  // 创建卡片
  buildView: () => WrappedBuilder<NavParam[]>;
}