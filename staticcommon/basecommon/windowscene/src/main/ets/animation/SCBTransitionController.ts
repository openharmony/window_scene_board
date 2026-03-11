/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import type HashMap from '@ohos.util.HashMap';
import type { OverlayCardInterface } from '../bean/OverlayCardData';
import { StartType, RectInfo } from '@ohos/basicutils';

const TAG = 'SCBTransitionController';

export class AppData {
  bundleName: string = '';
  abilityName: string = '';
  // 组件ID
  appIconId: string = '';
  iconRadius: number = 0;
  // 资源Id
  appIconNumber?: number = 0;
  cardId?: string;
  startAppType?: StartType = StartType.APP;
  extraId?: string;
  appIndex?: number;
  shortcutId?: string;
  isOpenFolder?: boolean;
  ino?: string;
  isOuterDesktop?: string;
  screenId?: number;
  persistentId?: string;
  appInstanceKey?: string;
}

export class AppInFolderInfo {
  folderId: string;
  isSmallFolder: boolean;
  index: number;
  size: number;
  bundleName: string;
  abilityName: string;
  appIndex: number;
  shortcutId: string;
  startType: StartType;
}

export class AppExitLocationInfo {
  type: string | null = null;
  isInScreen: boolean = false;
  pageIndex: number | null = null;
  iconRect: RectInfo | null = null;
  appInFolderInfo: AppInFolderInfo | null = null;
}

export class SCBTransitionControllerArray extends Array<SCBTransitionController> {
}

export class SCBAppExitToFolderControllerArray extends Array<SCBAppExitToFolderController> {
}

export class SCBFoldControllerArray extends Array<SCBFoldController> {
}

export class SCBExpandControllerArray extends Array<SCBExpandController> {
}

export class SCBTripleControllerArray extends Array<SCBTripleController> {
}

export interface TransitionFunc {
  (want?: HashMap<string, number | string>): void;
}

export interface SCBTransitionController {
  appData: AppData;
  onActive: Function;
  onActiveWithNoAnim?: Function;
  onInactive: Function;
  onInactiveWithNoAnim?: Function;
  onInactiveWithMoveStarting?: Function;
  cancelAnim?: Function;
  updateAnimSwipe?: Function;
  updateAnimSwipeEnd?: Function;
  cardDimension?: FormDimension;
  forward?: TransitionFunc;
  backward?: TransitionFunc;

  // 拓展overlay卡片启动场景
  overlayCardInfo?: OverlayCardInterface;
}

export interface SCBAppExitToFolderController {
  folderKey: string;
  onExitStart: (folderId: string, appIndex: number) => void;
  onExitEnd: (folderId: string, appIndex: number) => void;
}

export interface SCBFoldController {
  itemId: string;
  onFoldAnimation: Function;
}

export interface SCBExpandController {
  itemId: string;
  onExpandAnimation: Function;
}

export interface SCBTripleController {
  itemId: string;
  onTripleAnimation: Function;
}