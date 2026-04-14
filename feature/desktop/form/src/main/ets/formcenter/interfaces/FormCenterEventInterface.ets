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

import { Position } from '@kit.ArkUI';
import { FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { FormCenterContentBuilderInterface } from './FormCenterContentBuilderInterface';
import { FormCenterTitleParam, CenterTitleBuilderInterface } from './FormCenterTitleBuildeInterface';

export interface FormCenterEventInterface {
  showView: (param: FormCenterViewParam) => void;
  closeView: () => void;
  hideView: (height?: number) => void;
  getViewState: () => boolean;
  backGestureHandler: () => void;
  recoveryDefaultHeight?: () => void;
  onBindSheetAppear: () => void;
  onBindSheetDisAppear: () => void;
  onBindSheetDetentsDidChange: (height: number) => void;
  onBindSheetWillAppear: () => void;
  onBindSheetWillDisAppear: () => void;
  getTitleBuilder: () => CenterTitleBuilderInterface;
  getTitleBuilderParam: () => FormCenterTitleParam;
  getContentBuilder: () => FormCenterContentBuilderInterface;
  onBindSheetHeightDidChange?: () => void;
}