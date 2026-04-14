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

import { FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { SwiperLayoutEventInterface } from './SwiperLayoutEventInterface';
import { AttributeUpdater } from '@kit.ArkUI';
import { ManagerTitleBuilderInterface } from './FormManagerSheetTitleInterface';

export interface FormManagerEventInterface {
  showView: (param: FormCenterViewParam, callback: () => void) => void;
  closeView: () => void;
  hideView: () => void;
  getViewState: () => boolean;
  backGestureHandler: () => void;
  onBindSheetAppear?: () => void;
  onBindSheetWillDisAppear?: () => void;
  onBindSheetDisAppear?: () => void;
  onDetentsDidChange?: (height: number) => void;
  getTitleBuilder?: () => ManagerTitleBuilderInterface;
  getSwiperLayoutEvent: () => SwiperLayoutEventInterface;
  getFormNameUpdater?: () => AttributeUpdater<TextAttribute, TextInterface>;
}