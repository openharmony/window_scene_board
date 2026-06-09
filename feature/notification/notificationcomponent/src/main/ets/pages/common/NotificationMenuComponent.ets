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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  GlobalContext,
  ViewType,
  EvtBus,
  RequestWindowEvent,
  PluginSlot,
  HiDfxEventUtil,
  HiSysDataOperationType
} from '@ohos/frameworkwrapper';
import { NotificationConstants } from '../../common/NotificationConstants';
import { NotificationEntry } from '../../model/NotificationEntry';
import { NtfCloseVM } from '../../vm/NtfCloseVM';
import { NotificationRightMenu, RightMenuName } from './NotificationRightMenu';

const TAG = NotificationConstants.NTF_LOG_PREFIX + 'NotificationMenuComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

@Component
export struct NotificationMenuComponent {
  @Consume menuArea: Area | undefined;
  private ntfEntry?: NotificationEntry;
  @State isDisplayAtTop: boolean | undefined = false;
  private changeAppPinTopConfig?: (enable: boolean) => void
  /**
   * close按钮VM
   */
  @Consume private closeVM?: NtfCloseVM;

  build() {
    Row() {
      NotificationRightMenu({
        ntfEntry: this.ntfEntry,
        changeAppPinTopConfig: this.changeAppPinTopConfig,
        onItemClick: (item) => {
          if (this.ntfEntry) {
            // 点击事件处理
            if (item.menuName == RightMenuName.MenuEnableNtf) {
              this.closeVM?.setRightMenuItemClick(this.ntfEntry);
              HiDfxEventUtil.reportNtfRightTopMenuDisableClick(this.ntfEntry.creatorBundleName);
            } else if (item.menuName == RightMenuName.MenuPinTop) {
              this.isDisplayAtTop = this.ntfEntry?.isDisplayAtTop;
              let pinTop = !this.isDisplayAtTop;
              HiDfxEventUtil.reportNtfSetPinTop(pinTop ? HiSysDataOperationType.INSERT : HiSysDataOperationType.DELETE,
                this.ntfEntry?.creatorBundleName!);
              ContextMenu.close()
            } else if (item.menuName == RightMenuName.MenuMoreSetting) {
              HiDfxEventUtil.reportNtfRightTopMenuMoreSettingClick(this.ntfEntry.creatorBundleName);
              // 跳转通知管理页面，收起弹窗后，再收起通知面板
              let requestEvent = RequestWindowEvent.create(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL,
                RequestWindowEvent.REQUEST_HIDE);
              EvtBus.post(RequestWindowEvent, requestEvent);
            }
          }
        }
      })
    }
    .onDisAppear(() => {
      log.showInfo('right menu onDisAppear');
      this.menuArea = undefined;
      this.closeVM?.clearRightMenuDeletingItem();
    })
    .onBlur(() => {
      log.info('right menu onBlur');
      GlobalContext.getContext().eventHub.emit('SubWindowVisible', ViewType.NOTIFICATION_CENTER, false);
    })
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.menuArea = newValue;
    })
  }
}