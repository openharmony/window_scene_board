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
import { window } from '@kit.ArkUI';
import { EditModeBarViewData } from '../viewData/EditModeBarViewData';
import { EditModeGridData } from '../viewData/EditModeGridViewData';
import { EditModeStyleParam } from '../style/EditModeStyle';

export interface EditModeBarIface extends EditModeAcceptor {
  jumpBack: () => void;
  confirm: () => void;
  onGetViewData: () => EditModeBarViewData;
}

export interface EditModePanelIface extends EditModeAcceptor {
  onStartShow: () => void;
  onShow: () => void;
  onHide: () => void;
  updatePanelRect: (rect: window.Rect, useAnim?: boolean) => void;
  getId: () => number;
}

export interface EditModeGridIface extends EditModeAcceptor {
  onGetViewData: () => EditModeGridData;
  onUpdateToggleData: (toggleData: string[]) => void;
  onGetToggleData: (isDeepCopy?: boolean) => string[];
  updateGridLayout: (param: EditModeStyleParam) => void;
  updateGridVisibility: (isVisible: boolean) => void;
  calculateGridHeight: (isAddToggle?: boolean) => number;
  linkToggleData: (toggleData: string[]) => void;
  getDragHandler: () => EditModeDragIface | undefined;
  onBtnClick: (slot: string) => void;
  setIsEditMode: (isEditMode: boolean) => void;
  onSnapShot: () => void;
  onGetSnapShot: () => string[];
}

export interface EditModeVisitor {
  onBtnClickCb: (slot: string, isSelected: boolean) => void;
  onConfirmCb: () => void;
  onTryRollback: () => void;
}

export interface EditModeAcceptor {
  acceptModeVisitor: (visitor: EditModeVisitor) => void;
}

export interface EditModeDragIface {
  isDragAble: (toggleSlot: string) => boolean;
  onDragStart: (x: number, y: number, toggleSlot: string) => void;
  onDragMove: (x: number, y: number, toggleSlot: string) => void;
  onDragEnd: () => void;
}