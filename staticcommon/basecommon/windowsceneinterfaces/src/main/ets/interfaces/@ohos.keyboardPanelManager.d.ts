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

import type { Callback } from './@ohos.base';
import inputMethod from '@ohos.inputMethod';
import { PanelFlag } from '@ohos.inputMethod.Panel';

/**
 * Keyboard panel manager.
 *
 * @namespace keyboardPanelManager
 * @syscap SystemCapability.MiscServices.InputMethodFramework
 * @systemapi Hide this for inner system use.
 * @since 12
 */
declare namespace keyboardPanelManager {
  /**
   * define type of the private command.
   */
  type CommandDataType = number | string | boolean;

  interface SysPanelStatus {
    inputType: number;
    flag: PanelFlag;
    width: number;
    height: number;
    isPanelRaised: boolean;
    needFuncButton: boolean;
  }

  /**
   * Register the callback of privateCommand from default input method.
   * @param type: 'panelPrivateCommand'
   */
  function on(type: 'panelPrivateCommand', callback: Callback<Record<string, CommandDataType>>): void;

  /**
   * @param type
   * @param callback
   * Unregister the callback of privateCommand from default input method.
   * @param type: 'panelPrivateCommand'
   */
  function off(type: 'panelPrivateCommand', callback?: Callback<Record<string, CommandDataType>>): void;

  /**
   * @param type
   * @param callback
   * @param type
   * @param callback
   * @param type
   * @param callback
   * Register the callback of isPanelShow from imf.
   * @param type: 'isPanelShow'
   */
  function on(type: 'isPanelShow', callback: Callback<SysPanelStatus>): void;

  /**
   * @param type
   * @param callback
   * @param type
   * @param callback
   * @param type
   * @param callback
   * Unregister the callback of isPanelShow from imf.
   * @param type: 'isPanelShow'
   */
  function off(type: 'isPanelShow', callback?: Callback<SysPanelStatus>): void;

  /**
   * @param privateCommand
   * send privateCommand to default input method
   */
  function sendPrivateCommand(privateCommand: Record<string, CommandDataType>): Promise<void>;

  /**
   * get the smart menu config from default input method
   */
  function getSmartMenuCfg(): Promise<string>;

  /**
   * get default input method
   */
  function getDefaultInputMethod(): inputMethod.InputMethodProperty;

  /**
   * connect System Cmd
   */
  function connectSystemCmd(): Promise<void>;
}

export default keyboardPanelManager;