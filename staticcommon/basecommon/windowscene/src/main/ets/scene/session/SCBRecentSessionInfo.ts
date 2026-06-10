/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import bundleManager from '@ohos.bundle.bundleManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneContainerSession } from './SCBSceneContainerSession';

export enum SCBRecentSessionState {
  UNKNOWN = 0,
  OUT_OF_RECENT,
  INIT = OUT_OF_RECENT,
  ENTER_RECENT_START,
  ENTER_RECENT_ALL_ANIMATE_START,
  ENTER_RECENT_ANIMATE_START,
  ENTER_RECENT_ANIMATE_STARTED,
  ENTER_RECENT_ANIMATING = ENTER_RECENT_ANIMATE_STARTED,
  ENTER_RECENT_ALL_ANIMATE_STARTED,
  ENTER_RECENT_ALL_ANIMATING = ENTER_RECENT_ALL_ANIMATE_STARTED,
  ENTER_RECENT_END,
  ENTER_RECENT_ANIMATE_FINISH,
  ENTER_RECENT_ALL_ANIMATE_FINISH,
  STABLE = ENTER_RECENT_ALL_ANIMATE_FINISH,
  EXIT_RECENT_START,
  EXIT_RECENT_ALL_ANIMATE_START,
  EXIT_RECENT_ANIMATE_START,
  EXIT_RECENT_ANIMATE_STARTED,
  EXIT_RECENT_ANIMATING = EXIT_RECENT_ANIMATE_STARTED,
  EXIT_RECENT_ALL_ANIMATE_STARTED,
  EXIT_RECENT_ALL_ANIMATING = EXIT_RECENT_ALL_ANIMATE_STARTED,
  EXIT_RECENT_END,
  EXIT_RECENT_ANIMATE_FINISH,
  EXIT_RECENT_ALL_ANIMATE_FINISH,
}

const TAG = 'SCBRecentSession';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class SCBRecentSessionHelper {
  public static setState(container: SCBSceneContainerSession, state: SCBRecentSessionState): void {
    if (container) {
      log.showDebug('container recent state change %{public}s to %{public}s: %{public}s',
        container.sessionData.recentSessionInfo.state, state, container.getName());
      container.sessionData.recentSessionInfo.state = state;
    }
  }

  public static getState(container: SCBSceneContainerSession): SCBRecentSessionState {
    if (container) {
      return container.sessionData.recentSessionInfo.state;
    }
    return SCBRecentSessionState.UNKNOWN;
  }

  public static init(container: SCBSceneContainerSession): void {
    if (container) {
      container.sessionData.recentSessionInfo.state = SCBRecentSessionState.INIT;
    }
  }
}

/**
 * Recent session info
 */
export class SCBRecentSessionInfo {
  /**
   * Recent session: session id
   */
  sessionId: number | undefined;

  /**
   * Recent session: bundle name
   */
  bundleName: string | undefined;

  /**
   * Recent session: ability name
   */
  abilityName: string | undefined;

  /**
   * Recent session: module name
   */
  moduleName: string | undefined;

  /**
   * Recent card width
   */
  width: number;

  /**
   * Recent card's background width
   */
  bgWidth: number;

  /**
   * Recent card height
   */
  height: number;

  /**
   * Recent card's background height
   */
  bgHeight: number;
  /**
   * Recent session: aspectRatio
   */
  aspectRatio: number;

  /**
   * Recent session: scaleX
   */
  scaleX: number;

  /**
   * Recent session: scaleY
   */
  scaleY: number;
  /**
   * Recent session: left
   * */
  left: number;

  /**
   * Recent session: top
   */
  top: number;

  /**
   * Recent session: animType
   */
  animType: number;

  /**
   * Recent session: rowNum
   */
  rowNum: number;

  /**
   * column in recent layout
   */
  column: number;

  /**
   * Recent session: isActive
   */
  isActive: boolean;

  /**
   * Recent session: isMinimizing
   */
  isMinimizing: boolean;

  /**
   * Recent session: used for pc recent animate
   */
  animateLeft: number;

  /**
   * Recent session: used for pc recent enter animate
   */
  enterAnimateTop: number;

  /**
   * Recent session: isSplitRecentPair
   */
  isSplitRecentPair: boolean;

  /**
   * Recent session: it's split screen up and down.
   */
  isUpDownSplit: boolean;

  /**
   * Recent Session: used for pc pair split on split recent view
   */
  secondaryWidth: number;

  /**
   * Recent Session: used for pc pair split on split recent view
   */
  secondaryAspectRatio: number;

  /**
   * Recent Session: support Window Mode
   */
  supportWindowModes: Array<bundleManager.SupportWindowMode>;

  /**
   * recent state
   */
  state: SCBRecentSessionState;

  /**
   * Recent session: used for pc recent exit animate
   */
  exitAnimateTop: number;
}