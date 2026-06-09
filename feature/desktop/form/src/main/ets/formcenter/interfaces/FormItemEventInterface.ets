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

import Want from '@ohos.app.ability.Want';
import { CardItemInfo } from '@ohos/launchercommon';
import { FormItemAnimaInterface, FormItemData } from '../viewmodel/data/FormItemVm';

export interface FormItemEventInterface {
  onTouch: (event: TouchEvent) => void;
  onZoomInLongPress: (event: GestureEvent) => void;
  onVibratorLongPress: (event: GestureEvent) => void;
  onClick: (event?: ClickEvent) => void;
  onDragStart: (event?: DragEvent, extraParams?: string) => DragItemInfo;
  onDragEnd: (event?: DragEvent) => void;
  onDisAppear: () => void;
  getFormWant: (formItem: CardItemInfo) => Want | undefined;
  getDragPreview?: () => CustomBuilder | DragItemInfo | string;
  onCardAcquired?: (cardId: string) => void;
  onCardLoad?: (cardId: string) => void;
  onCardError?: (cardId: string) => void;
  initAnimateData?: (formItemAnimData: FormItemAnimaInterface, index?: number) => void;
  initFormUIConfig: (formItemUIConfig: FormItemData, formScale?: number) => void;
  isDragable?: () => boolean;
  onPreDrag?: (status: PreDragStatus) => void;
  getFormItemSnapId: () => string;
  doFadeInAnimation?: (start: boolean) => void;
  getIsCurrentIndex?: (index: number) => boolean;
}