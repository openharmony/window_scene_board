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

import { CommonUtils } from '@ohos/basicutils';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { KeyValueArray, SCBDebugUtils } from './uiDumpUtils/SCBDebugUtils';
import { SCBInputMethodList } from '../session/SCBSceneSessionManager';
import { SCBKeyboardManager } from '../session/SCBKeyboardManager';
import { SCBKeyboardSession } from '../session/SCBKeyboardSession';
import { SCBKeyboardPanelSession } from '../session/SCBKeyboardPanelSession';

const TAG = 'SCBKeyboard';

export class SCBKeyboardDebugCommands {
  private readonly keyboardSessionList: SCBInputMethodList;

  constructor(keyboardSessionList: SCBInputMethodList) {
    this.keyboardSessionList = keyboardSessionList;
  }

  private buildSCBKeyboardSessionList(keyboardSessionList: SCBInputMethodList): string {
    if (CommonUtils.isInvalid(keyboardSessionList)) {
      return '';
    }
    let arr: KeyValueArray[] = [];
    keyboardSessionList.forEach((keyboardSession) => {
      arr.push(this.buildSCBKeyboardSessionKeyValues(keyboardSession));
    });
    return SCBDebugUtils.buildArrayContext(arr);
  }

  private buildSCBKeyboardSession(session: SCBKeyboardSession | SCBKeyboardPanelSession): string {
    let arr: KeyValueArray[] = [];
    if (session instanceof SCBKeyboardSession) {
      arr.push(this.buildSCBKeyboardSessionKeyValues(session));
    } else if (session instanceof SCBKeyboardPanelSession) {
      arr.push(this.buildSCBKeyboardPanelSessionKeyValues(session));
    }
    return SCBDebugUtils.buildArrayContext(arr);
  }

  private buildSCBKeyboardSessionKeyValues(session: SCBKeyboardSession): KeyValueArray {
    let array: KeyValueArray = new KeyValueArray();
    if (CommonUtils.isInvalid(session)) {
      return array;
    }
    array.push('id', session.session?.persistentId);
    array.push('type', session.session?.type);
    array.push('refCount', session.refCount);
    array.push('isActive', session.isActive);
    array.push('sessionState', session.sessionData.sessionState);
    array.push('visibility', session.visibility);
    array.push('isFocusable', session.isFocusable);
    array.push('keyboardOffset', session.keyboardOffset);
    array.push('translatePosY', session.translatePosY);
    array.push('sessionGravity', session.sessionGravity);
    array.push('currRect', session.currRect);
    array.push('keyboardPanelRects', session.keyboardPanelRects);
    array.push('rectForFingerprint', session.rectForFingerprint);
    array.push('specialBoarderRadius', session.specialBoarderRadius);
    array.push('isWindowShowAnimate', session.isWindowShowAnimate);
    array.push('isCustomAnimationPlaying', session.isCustomAnimationPlaying);
    array.push('isTouchable', session.isTouchable);
    array.push('isRotating', session.isRotating);
    array.push('isSyncTransactionOpen', session.isKeyboardSyncTransactionOpen());
    array.push('keyboardState', SCBKeyboardManager.getInstance().getKeyboardState());
    return array;
  }

  private buildSCBKeyboardPanelSessionKeyValues(session: SCBKeyboardPanelSession): KeyValueArray {
    let array: KeyValueArray = new KeyValueArray();
    if (CommonUtils.isInvalid(session)) {
      return array;
    }
    array.push('id', session.session?.persistentId);
    array.push('name', session.name);
    array.push('type', session.session?.type);
    array.push('visibility', session.visibility);
    array.push('currRect', session.currRect);
    array.push('isShowPanel', session.isShowPanel);
    array.push('isLandscape', session.isLandscape);
    array.push('rightIcon', session.rightIcon);
    array.push('isActive', session.isActive);
    array.push('smartButtonInfo', session.smartButtonInfo);
    array.push('rightSelectedIcon', session.rightSelectedIcon);
    array.push('toolbarPaddingLeft', session.toolbarPaddingLeft);
    array.push('toolbarPaddingRight', session.toolbarPaddingRight);
    array.push('isExpandStatus', session.isExpandStatus);
    array.push('isHotSwitch', session.getIsHotSwitch());
    array.push('patternOption', session.getPatternOption());
    array.push('smartMenu', session.getSmartMenu());
    array.push('backgroundColor', session.backgroundColor);
    array.push('borderRadius', session.borderRadius);
    array.push('radius', session.radius);
    array.push('backdropBlur', session.backdropBlur);
    return array;
  }

  public register(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'keyboardSessionList',
        callback: (): string => {
          return this.buildSCBKeyboardSessionList(this.keyboardSessionList);
        }
      },
      {
        cmdName: 'keyboardSession',
        callback: (): string => {
          return this.buildSCBKeyboardSession(SCBKeyboardManager.getInstance().getKeyboardSession());
        }
      },
      {
        cmdName: 'keyboardPanelSession',
        callback: (): string => {
          return this.buildSCBKeyboardSession(SCBKeyboardManager.getInstance().getPanelSession());
        }
      },
      {
        cmdName: 'systemKeyboard',
        callback: (): string => {
          return this.buildSCBKeyboardSession(SCBKeyboardManager.getInstance().getSystemKeyboardSession());
        }
      },
      {
        cmdName: 'systemPanelSession',
        callback: (): string => {
          return this.buildSCBKeyboardSession(SCBKeyboardManager.getInstance().getSystemPanelSession());
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

  public unregister(): void {
    DebugCommandManager.getInstance().unregister(TAG);
  }
}