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
import common from '@ohos.app.ability.common';
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { PluginAccessInfo, GlobalContext, ViewType, PluginSlot, SettingsUtil } from '@ohos/frameworkwrapper';
// import statusBar from '@hms.pcService.statusBar';
import { PluginProperty } from '../viewdata/PluginProperty';
import { MenuStyle } from '@ohos/plugincomponent/src/main/ets/style/MenuStyle';
import { AppClientNotifier } from '@ohos/statusbarextensionservice';
import { windowMgr } from '@ohos/windowscene';
import { trayPanelMenuVM } from '../viewmodel/TrayPanelMenuVM';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { LengthMetrics } from '@kit.ArkUI';
import { StatusBarEventId, StatusBarEventManager } from '../manager/StatusBarEventManager';
import { PluginDragEvent } from '../utils/events';

const TAG = 'PcAccessRightMenu';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export struct PcAccessRightMenu {
  @ObjectLink property: PluginProperty;
  menuStyle: MenuStyle = new MenuStyle();
  isTrayPanelMenu: boolean = false;
  @Consume isMenuOpen: boolean;
  @Consume isMenuOpenNotTray: boolean;

  @Builder
  subMenu(subMenus: ESObject[]) {
    Menu() {
      ForEach(subMenus, (subMenuItem: ESObject) => {
        MenuItem({
          content: subMenuItem.subTitle,
        })
          .id(`${TAG}_subRightMenuItem`)
          .onClick(() => {
            this.onMenuClick(subMenuItem.menuAction);
            ContextMenu.close();
          })
          .height(this.menuStyle.defaultMenuHeight)
      }, (subMenuItem: ESObject) => JSON.stringify(subMenuItem))
    }
    .width(this.menuStyle.defaultMenuWidth)
  }

  @Builder
  mainMenuItem(item: ESObject, index: number) {
    MenuItem({
      content: item.title,
      endIcon: this.updateIcon(item.subMenu),
      builder: item.subMenu && item.subMenu.length ? (): void => this.subMenu(item.subMenu) : undefined,
    })
      .id(`${TAG}_RightMenuItem`)
      .height(this.menuStyle.defaultMenuHeight)
      .margin({
        top: index === 0 ? 0 : this.menuStyle.menuTopMargin,
      })
      .onClick(() => {
        if (!(item.subMenu && item.subMenu.length)) {
          AppStorage.setOrCreate('isRightMenuOpen', false);
          this.onMenuClick(item.menuAction);
          ContextMenu.close();
          windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_TRAY_PANEL);
        }
      })
  }

  @Builder
  groupMenu(menuData: ESObject) {
    if (!ArrayUtils.isEmpty(menuData)) {
      MenuItemGroup() {
        ForEach(menuData, (item: ESObject, index: number) => {
          this.mainMenuItem(item, index)
        }, (item: ESObject) => JSON.stringify(item))
      }
      .margin({
        bottom: StyleConstants.MENU_MARGIN
      })

      Divider()
        .vertical(false)
        .color($r('sys.color.ohos_id_color_list_separator'))
        .strokeWidth('1px')
        .margin({
          left: StyleConstants.DEFAULT_12,
          right: StyleConstants.DEFAULT_12,
          bottom: StyleConstants.MENU_MARGIN
        })
    }
  }

  build() {
    Menu() {
      if (!ArrayUtils.isEmpty(this.property.groupMenuInfo)) {
        ForEach(this.property.groupMenuInfo, (menuData: ESObject) => {
          this.groupMenu(menuData)
        })
      }
      MenuItemGroup() {
        MenuItem({
          content: this.menuStyle.exitItemText,
        })
          .onClick(() => {
            this.onExitMenuClick();
          })
          .id(`${TAG}_RightMenuExitItem`)
          .height(this.menuStyle.defaultMenuHeight)
      }
    }
    .menuItemGroupDivider({
      strokeWidth: new LengthMetrics(0)
    })
    .onDisAppear(() => {
      log.showInfo(`PcAccessRightMenu onDisAppear`);
    })
    .padding({
      left: this.menuStyle.menuContainerLeftPadding,
      right: this.menuStyle.menuContainerRightPadding,
      top: this.menuStyle.menuContainerTopPadding,
      bottom: this.menuStyle.menuContainerBottomPadding,
    })
    .width(this.menuStyle.defaultMenuWidth)
    .borderRadius(this.menuStyle.menuContainerRadius)
  }

  private updateIcon(subMenus?: ESObject[]): Resource | undefined {
    if (subMenus && subMenus.length > 0) {
      return $r('sys.media.ohos_ic_public_arrow_right');
    }
    return undefined;
  }

  private onMenuClick(menuAction?: ESObject): void {
    if (!menuAction) {
      return;
    }
    try {
      const pluginSlot = this.property.getSlot();
      const bundleName = this.property.pluginInfo?.pluginParseInfo?.bundleName ?? '';
      const menuCode: string = menuAction?.menuCode ?? '';
      log.showInfo(`onMenuClick bundleName: ${bundleName} pluginSlot ${pluginSlot},
        menuCode: ${menuCode}, notifyOnly: ${menuAction.notifyOnly}`);
      if (menuAction.notifyOnly && menuCode !== '') {
        AppClientNotifier.getInstance().notifyClientMenuClicked(pluginSlot, menuCode);
      }

      let want: Want = {
        bundleName: bundleName,
        abilityName: menuAction.abilityName,
        moduleName: menuAction.moduleName,
      };
      let context = getContext(this) as common.UIAbilityContext;
      context.startAbility(want);
      log.showInfo(`explicit start ability succeed`);
    } catch (error) {
      log.showError(`explicit start ability failed with ${error.code}`);
    }
  }

  private onExitMenuClick(): void {
    log.showInfo(`${TAG}: exit is clicked`);
    if (this.property.pluginInfo?.pluginParseInfo?.isAccessPlugin) {
      let accessPluginInfo = this.property.pluginInfo as PluginAccessInfo;
      let exitPidArray: number[] = [];
      exitPidArray.push(...Array.from(accessPluginInfo.pids));
      exitPidArray.push(...Array.from(accessPluginInfo.attachPids));
    }
    ContextMenu.close();
  }

  aboutToAppear() {
    log.showInfo(`${TAG} ${this.property.getSlot()} Right-click menu aboutToAppear.`);
    StatusBarEventManager.getInstance().onSpecial(TAG, StatusBarEventId.PLUGIN_DRAG_EVENT, this.onPluginDragEvent);
  }

  aboutToDisappear(): void {
    log.showInfo(`${TAG} ${this.property.getSlot()} Right-click menu aboutToDisappear.`);
    StatusBarEventManager.getInstance().offSpecial(TAG, StatusBarEventId.PLUGIN_DRAG_EVENT, this.onPluginDragEvent);
  }

  onPluginDragEvent = (pluginDragEvent: PluginDragEvent) => {
    log.showInfo(`plugin drag event :${JSON.stringify(pluginDragEvent)}`);
    // 非长按access图标呼出右键菜单后拖拽不处理，避免多次处理右键菜单关闭事件
    if (!pluginDragEvent.isAccessPlugin || pluginDragEvent.slot !== this.property.getSlot()) {
      return;
    }
    if (!this.isTrayPanelMenu) {
      this.isMenuOpenNotTray = false;
    }
    this.isMenuOpen = false;
  }
}