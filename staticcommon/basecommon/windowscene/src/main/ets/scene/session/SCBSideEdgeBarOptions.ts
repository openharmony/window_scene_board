/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { SCBSessionRect } from './SCBSessionRect';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';

const SIDE_EDGE_WIDTH = 20;
const SIDE_EDGE_HEIGHT = 104;
const SIDE_EDGE_POS_Y = 96;
const SIDE_EDGE_BORDER = 16;
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { isLargeFoldProductInExpand } from './SCBDividerParam';

const TAG = 'SCBSideEdgeBarOptions';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

@Observed
export class SCBSideEdgeBarOptions {
  /**
   * persistentId: means which floating scene in sideEdgeBar
   */
  persistentId: number = -1;

  borderRadius: number = SIDE_EDGE_BORDER;

  opacity: number = 1;

  visibility: Visibility = Visibility.Visible;

  posX: number = 0;

  posY: number = SIDE_EDGE_POS_Y;

  width: number = SIDE_EDGE_WIDTH;

  height: number = SIDE_EDGE_HEIGHT;

  tranX: number = 0;

  tranY: number = 0;

  displayState: SCBSideEdgeBarDisplayState = SCBSideEdgeBarDisplayState.NONE;

  panelShow: boolean = false;

  sideEdgePositionX: number = 0;

  sideEdgeWidth: number = SCBSideManagerConstant.SIDE_MANAGER_WIDTH + SCBSideManagerConstant.SIDE_MANAGER_MARGIN_LEFT +
  SCBSideManagerConstant.SIDE_MANAGER_MARGIN_RIGHT;

  touchRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);

  scale: number = 1;

  length: number = 0;

  scrollOffsetY: number = 0;

  isAnimIng: boolean = false;

  commit: number = 0;

  bgRadius: number = 100;

  bgScale: number = 1;

  enableScroll: boolean = true;

  isNeedBackground: boolean = true;
}

export class SCBSideManagerConstant {
  static readonly SIDE_MANAGER_WIDTH = 148;
  static readonly SIDE_MANAGER_WIDTH_FOLD = 200;
  static readonly SIDE_MANAGER_WIDTH_PAD = 240;
  static readonly SIDE_MANAGER_CARD_RADIUS = 14;
  static readonly SIDE_MANAGER_ICON_WIDTH = 28;
  static readonly SIDE_MANAGER_ICON_HEIGHT = 28;
  static readonly SIDE_MANAGER_ICON_RADIUS = 14 / 54 * 28;
  static readonly SIDE_MANAGER_ICON_MARGIN = 12;
  static readonly SIDE_MANAGER_TEXT_MARGIN = 8;
  static readonly SIDE_MANAGER_MARGIN_LEFT = 16;
  static readonly SIDE_MANAGER_MARGIN_RIGHT = 16;
  static readonly SIDE_MANAGER_CARD_SPACING = 16;
  static readonly SIDE_MANAGER_SPACING = 8;
  static readonly SIDE_MANAGER_FONT_SIZE = 24;
  static readonly SIDE_MANAGER_TOP_MARGIN = 36;
  static readonly SIDE_MANAGER_TOUCH_SCALE = 0.95;
  static readonly SIDE_MANAGER_EXIT_SCALE = 0.3;

  public static getRealWidth(): number {
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PAD) {
      return SCBSideManagerConstant.SIDE_MANAGER_WIDTH_PAD;
    }
    let isExpandStatus = isLargeFoldProductInExpand();
    if (isExpandStatus) {
      return SCBSideManagerConstant.SIDE_MANAGER_WIDTH_FOLD;
    }
    return SCBSideManagerConstant.SIDE_MANAGER_WIDTH;

  }
}

export enum SCBSideEdgeBarDisplayState {
  NONE,
  SHOW,
  HIDDEN
}