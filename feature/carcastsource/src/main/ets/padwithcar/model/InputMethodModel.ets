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
import { SCBKeyboardPanelSession, SCBKeyboardSession, SCBScreenProperty } from '@ohos/windowscene/src/main/ets/TsIndex';
import sceneSessionManager from '@ohos.sceneSessionManager';

export default class InputMethodModel {
  /**
   * panelEnable
   */
  public panelEnable: boolean = false;
  /**
   * 输入法面板状态
   */
  public keyBoardState: sceneSessionManager.SessionState = sceneSessionManager.SessionState.STATE_DISCONNECT;
  /**
   * 是否显示动画
   */
  public mIsShowAnimation: boolean = false;
  /**
   * keyBoardHeight
   */
  public keyBoardHeight: number = 0;
  /**
   * keyBoardWidth
   */
  public keyBoardWidth: number = 0;
  /**
   * top
   */
  public top: number = 0;
  /**
   * SCBKeyboardSession
   */
  public keyboardSession?: SCBKeyboardSession;
  /**
   * SCBKeyboardPanelSession
   */
  public keyboardPanelSession?: SCBKeyboardPanelSession;
  /**
   * 虚拟屏信息
   */
  public screenProperty?: SCBScreenProperty;
}