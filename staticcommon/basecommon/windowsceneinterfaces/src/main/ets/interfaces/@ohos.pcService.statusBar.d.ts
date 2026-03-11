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

import image from '@ohos.multimedia.image';
import rpc from '@ohos.rpc';

/**
 * The desktop status bar .
 * @namespace statusBar
 * @syscap SystemCapability.PCService.StatusBarManager
 * @since 5.0.0(12)
 */
declare namespace statusBar {
  /**
   * The details of the StatusBar item.
   * @syscap SystemCapability.PCService.StatusBarManager
   * @since 5.0.0(12)
   */
  interface StatusBarItem {
    /**
     * The icon information.
     * @type { StatusBarIcon }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    icons: StatusBarIcon;

    /**
     * Quick operation information in the left-click pop-up window.
     * @type { QuickOperation }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    quickOperation: QuickOperation;

    /**
     * Information about the right-click menu of the icon in the status bar.
     * @type { Array<StatusBarGroupMenu> }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    statusBarGroupMenu?: Array<StatusBarGroupMenu>;
  }

  /**
   *  The app icon in status bar.
   * @syscap SystemCapability.PCService.StatusBarManager
   * @since 5.0.0(12)
   */
  interface StatusBarIcon {
    /**
     * The icon on a dark background
     * @type { image.PixelMap }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    white: image.PixelMap;

    /**
     * The icon on a light background.
     * @type { image.PixelMap }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    black: image.PixelMap;
  }

  /**
   * The menu group infomation of the icon of status bar.
   * @syscap SystemCapability.PCService.StatusBarManager
   * @since 5.0.0(12)
   */
  type StatusBarGroupMenu = Array<StatusBarMenuItem>;

  /**
   * The information of single menu item in the status bar.
   * @syscap SystemCapability.PCService.StatusBarManager
   * @since 5.0.0(12)
   */
  interface StatusBarMenuItem {
    /**
     * The title of the menu item.
     * @type { string }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    title: string;
    /**
     * The action information of the menu item.
     * @type { string }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    menuAction?: StatusBarMenuAction;
    /**
     * Submenu information.
     * @type { Array<StatusBarSubMenuItem> }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    subMenu?: Array<StatusBarSubMenuItem>;
  }

  /**
   * Menu Item Action.
   * The function of starting ability of the current application is supported currently.
   * @syscap SystemCapability.PCService.StatusBarManager
   * @since 5.0.0(12)
   */
  interface StatusBarMenuAction {
    /**
     * ability name of application.
     * @type { string }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    abilityName: string;
    /**
     * The description of an module name in an want.
     * @syscap SystemCapability.PCService.StatusBarManager
     * @crossplatform
     * @atomicservice
     * @since 5.0.0(12)
     */
    moduleName?: string;
    /**
     * right menu click enable.
     * @type { ?boolean }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    notifyOnly?: boolean;
    /**
     * right menu code.
     * @type { ?string }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    menuCode?: string;
  }
  /**
   * The information of submenu item in the statusbar.
   * @syscap SystemCapability.PCService.StatusBarManager
   * @since 5.0.0(12)
   */
  interface StatusBarSubMenuItem {
    /**
     * The title of the submenu item.
     * @type { string }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    subTitle: string;
    /**
     * The action information of the submenu item.
     * @type { string }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    menuAction: StatusBarMenuAction;
  }

  /**
   * Quick operation information in the left-click pop-up window corresponding to the icon in the status bar.
   * @syscap SystemCapability.PCService.StatusBarManager
   * @since 5.0.0(12)
   */
  interface QuickOperation {
    /**
     * The title of QuickOperation.
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    title: string;
    /**
     * The height of QuickOperation.
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    height: number;
    /**
     * The Name of the custom UIExtensionAbility
     * @type { ?string }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    abilityName?: string;
    /**
     * The description of an module name in an want.
     * @type { ?string }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 5.0.0(12)
     */
    moduleName?: string;
    /**
     * @type { ?boolean }
     * @syscap SystemCapability.PCService.StatusBarManager
     * @since 6.0.0(20)
     */
    loadingStatus?: boolean;
  }

  /**
   * read statusBarItem from parcel
   *
   * @param { rpc.MessageSequence } data - The rpc remote request data.
   * @returns { StatusBarItem } The StatusBar Item info.
   */
  function readStatusBarItemFromParcel(data: rpc.MessageSequence): StatusBarItem;

  /**
   * read statusBarIcon from parcel. This method is only for 2in1 or pc.
   *
   * @param { rpc.MessageSequence } data - The rpc remote request data.
   * @returns { StatusBarItem } The StatusBar Icon.
   */
  function readIconsFromParcel(data: rpc.MessageSequence): StatusBarIcon;

  /**
   * read the array of StatusBarGroupMenu from parcel. This method is only for 2in1 or pc.
   *
   * @param { rpc.MessageSequence } data - The rpc remote request data.
   * @returns { Array<StatusBarGroupMenu> } The array of StatusBarGroupMenu.
   */
  function readGroupMenuArrayFromParcel(data: rpc.MessageSequence): Array<StatusBarGroupMenu>;

  /**
   * read the calling app instanceKey.
   *
   * @param { rpc.MessageSequence } data - The rpc remote request data.
   * @returns { string } The instanceKey of calling app.
   */
  function readInstanceKeyToParcel(data: rpc.MessageSequence): string;

  /**
   * write statusBarItem to parcel. This method is only for 2in1 or pc.
   *
   * @param { StatusBarItem } item - The StatusBar Item info.
   * @param { rpc.MessageSequence } data - The rpc remote request data.
   */
  function writeStatusBarItemToParcel(item: StatusBarItem, data: rpc.MessageSequence): void;

  /**
   * write statusBar Icons to parcel. This method is only for 2in1 or pc.
   *
   * @param { StatusBarItem } icons - The StatusBar Icon.
   * @param { rpc.MessageSequence } data - The rpc remote request data.
   */
  function writeIconsToParcel(icons: StatusBarIcon, data: rpc.MessageSequence): void;

  /**
   * write GroupMenuArray to parcel. This method is only for 2in1 or pc.
   *
   * @param { Array<StatusBarGroupMenu> } groupMenu - The array of StatusBarGroupMenu.
   * @param { rpc.MessageSequence } data - The rpc remote request data.
   */
  function writeGroupMenuArrayToParcel(groupMenu: Array<StatusBarGroupMenu>, data: rpc.MessageSequence): void;

  /**
   * create tray for app by accessTokenId. This method is only for 2in1 or pc.
   *
   * @param { number } accessTokenId - The accessTokenId of application.
   * @param { string } instanceKey - The instance key of application.
   */
  function createTrayForApp(accessTokenId: number, instanceKey: string): void;

  /**
   * delete tray for app by accessTokenId. This method is only for 2in1 or pc.
   *
   * @param { number } accessTokenId - The accessTokenId of application.
   * @param { string } instanceKey - The instance key of application.
   */
  function deleteTrayForApp(accessTokenId: number, instanceKey: string): void;

  /**
   * create tray manager for status bar. This method is only for 2in1 or pc.
   *
   * @param { Function } callback - When background process is attached to tray, callback is called.
   */
  function createTrayManager(callback: (accessTokenId: number, pid: number, instanceKey: string, isDetached: boolean) => void): void;

  /**
   * delete tray manager. This method is only for 2in1 or pc.
   */
  function deleteTrayManager(): void;

  /**
   * exit processes by pid. This method is only for 2in1 or pc.
   *
   * @param { Array<number> } pids - The array for pid.
   */
  function exitProcesses(pids: Array<number>): void;
}

export default statusBar;