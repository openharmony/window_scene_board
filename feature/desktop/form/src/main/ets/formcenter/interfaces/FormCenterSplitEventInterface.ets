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

import { CardItemInfo } from '@ohos/launchercommon';
import { NavDestinationParam } from '../viewmodel/factory/NavDestinationFactory';
import { NavDestinationBuilderInterface } from './NavDestinationBuilderInterface';

export interface FormCenterSplitEventInterface {
  onAppear?: () => void;
  onDisAppear?: () => void;
  getInitIndex: () => number;
  onIndexChange: (index: number) => void;
  getBuildInterface: (param: NavDestinationParam) => NavDestinationBuilderInterface;
  pushPathByName: (name: string) => void;
  onListItemClick?: (event: ClickEvent, bundleName: string) => void;
  initData: (startFormInfo: CardItemInfo, formCenterPage: NavPathStack) => void;
}