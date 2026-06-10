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
import osAccount from '@ohos.account.osAccount';
import {
  MultiSpaceSwitchOneGoCtrl,
  SwitchEnterpriseMultiSpaceType
} from '../../../common/EnterpriseMultiSpaceController';
import { IUserItemConfig, UserItemStyle, UserItemVM } from '../../userspanel/component/UserList/UserList';
import { UserButtonVM } from '../../userspanel/component/UserButton/UserButton';
import { UserTextStyle } from '../../userspanel/component/UserText/UserText';
import { UserAvatarUtils } from '../../userspanel/common/UserAvatarUtils';
import { AvatarVM } from '../../userspanel/component/Avatar/AvatarViewModel';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import {
  CapsuleVisibleEvent,
  EventManager, EvtBus, GlobalContext, OobeActivatedEvent, PluginRequestEvent,
  PluginSlot } from '@ohos/frameworkwrapper';
import { systemParameterEnhance } from '@kit.BasicServicesKit';

const TAG: string = 'EnterpriseSpacePanelVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const accountManager: osAccount.AccountManager = osAccount.getAccountManager();
const SWIPE_DIRECTION_LEFT: number = 2;
const MAX_TITLE_SCALE: number = 1.4;
const MAX_FONT_SCALE: number = 1.25;
export enum SpaceIdEnum {
  ENTERPRISE = 100,
  PERSONAL = 101
}

@Observed
export class EnterpriseSpacePanelVM extends ToggleBaseViewModel {
  private eventManager: EventManager = EvtBus.createEventManager();
  private isVisible: boolean = false;
  public title: ResourceStr = $r('app.string.space_switching');
  public titleStyle: UserTextStyle = new UserTextStyle({
    size: $r('sys.float.Title_S'),
    maxFontScale: MAX_TITLE_SCALE,
    maxLines: 1,
    weight: FontWeight.Bold,
    color: $r('sys.color.font_secondary')
  });
  public userList: UserItemVM[] = [];
  private statusBarVisibleData: CapsuleVisibleEvent | null = null;
  private onStatusBarVisibleEvent = (): CapsuleVisibleEvent | null => {
    return this.statusBarVisibleData;
  }

  public clear(): void {
    this.userList = [];
  }

  constructor() {
    super();
    this.onStart();
  }

  public async checkIsEnterpriseSpaceEnabled(): Promise<boolean> {
    log.showInfo('checkIsEnterpriseSpaceEnabled invoked');
    try {
      const enable: boolean =
        systemParameterEnhance.getSync('persist.space_mgr_service.enterprise_space_enable', 'empty') === 'true';
      log.showInfo(`checkIsEnterpriseSpaceEnabled enable ${enable}`);
      const isPersonalSpaceInit = await this.isPersonalSpaceInit();
      return enable && isPersonalSpaceInit;
    } catch (err) {
      log.showError(`checkIsEnterpriseSpaceEnabled failed. Error ${err?.code} ${err?.message}`);
      return false;
    }
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    EvtBus.produceOn(CapsuleVisibleEvent, this.onStatusBarVisibleEvent);
    this.eventManager.on(OobeActivatedEvent, (event: OobeActivatedEvent) => {
      log.showInfo(`OobeActivatedEvent isActivated ${event.isActivated}`);
      this.handleStatusBarState();
    })
    this.handleStatusBarState();
  }

  onStop(): void {
    EvtBus.produceOff(CapsuleVisibleEvent, this.onStatusBarVisibleEvent);
    this.eventManager.offAll();
  }

  async handleStatusBarState() {
    // 发送事件，触发PluginRootComponent组件中的状态更新，进而统一控制整个图标的显示与隐藏。
    this.isVisible = await this.checkIsEnterpriseSpaceEnabled();
    log.showInfo(`handleStatusBarState, newState:${this.isVisible}`)
    this.sbPluginRequest.setIsVisible(this.isVisible);
    EvtBus.post(PluginRequestEvent, this.sbPluginRequest);

    this.statusBarVisibleData = { 
      pluginSlot: this.getSbPluginSlot(),
      visible: this.isVisible 
    } as CapsuleVisibleEvent;
    // 胶囊事件
    EvtBus.post(CapsuleVisibleEvent, this.statusBarVisibleData);
  }

  /**
   * 企业空间图标标示
   */
  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE;
  }

  isAvailable(): boolean {
    return true;
  }

  public async isPersonalSpaceInit(): Promise<boolean> {
    log.showInfo(TAG, 'isPersonalSpaceInit invoked');
    try {
      let accountList: osAccount.OsAccountInfo[] = await accountManager.queryAllCreatedOsAccounts();
      log.showInfo(TAG, `accountList.length: ${accountList?.length}`);
      if (accountList.length > 1) {
        log.showInfo(TAG, 'Personal Space Init');
        return true;
      }
      log.showInfo(TAG, 'Personal Space not Init');
      return false;
    } catch (err) {
      log.showError(TAG, `queryAllCreatedOsAccounts failed with error ${err?.code} ${err?.message}`);
      return false;
    }
  }

  public async updateUserList(): Promise<void> {
    log.showInfo('updateUserList invoked');
    const list: UserItemVM[] = [];
    try {
      let accountList: osAccount.OsAccountInfo[] = await accountManager.queryAllCreatedOsAccounts();
      log.showInfo(`accountList length ${accountList.length}`);
      const currentUserId: number = await accountManager.getForegroundOsAccountLocalId();
      let currentSpaceItem: EnterpriseSpaceItemVM | null = null;
      for (const account of accountList) {
        if (account.localId === currentUserId) {
          currentSpaceItem = EnterpriseSpaceItemVM.createEnterpriseSpaceItemVM(account, true);
        } else {
          list.push(EnterpriseSpaceItemVM.createEnterpriseSpaceItemVM(account));
        }
      }
      if (currentSpaceItem !== null) {
        list.unshift(currentSpaceItem);
      }
      this.userList = list;
      this.userList.map(item => {
        if (item.account.localId === SpaceIdEnum.ENTERPRISE) {
          item.avatar = new AvatarVM({
            src: $r('app.media.ic_enterprise_space'),
            imgSize: 32,
            badge: item.account.isLoggedIn,
          });
        }
      })
      log.showInfo(`updateUserList successfully. userList length ${this.userList.length}`);
    } catch (err) {
      log.showError(`updateUserList with error ${err?.code} ${err?.message}`);
    }
  }

  public getHeight(): number {
    log.showInfo('getHeight invoked');
    const baseHeight: number = 120;
    const itemHeight: number = 56;
    return baseHeight + (itemHeight * this.userList.length);
  }
}

@Observed
export class EnterpriseSpaceItemVM extends UserItemVM {
  public static createEnterpriseSpaceItemVM(account: osAccount.OsAccountInfo,
    isForeground: boolean = false): EnterpriseSpaceItemVM {
    const spacePanelUserItemConfig: IUserItemConfig = EnterpriseSpaceItemVM.getSpacePanelUserItemConfig(account);
    const userItem: EnterpriseSpaceItemVM = new EnterpriseSpaceItemVM(account, spacePanelUserItemConfig);
    if (isForeground) {
      userItem.button = new UserButtonVM({
        id: 'exit_space_button',
        text: $r('app.string.confirm_logout_button'),
        onClick: () => {
          EnterpriseSpaceItemVM.exitSpace(account.localId);
        },
      });
    } else {
      userItem.onClick = () => {
        EnterpriseSpaceItemVM.switchSpace(account.localId);
      }
    }
    // 头像右下角标去掉 stroke
    userItem.avatar.badgeModifier.stroke = undefined;
    userItem.avatar.badgeModifier.strokeWidth = undefined;
    return userItem;
  }

  public getSubText(): ResourceStr {
    log.showInfo(`getText invoked ${this.account.localId}`);
    if (this.account.localId === SpaceIdEnum.ENTERPRISE) {
      log.showInfo(`SpaceIdEnum.ENTERPRISE`);
      return $r('app.string.enterprise_space');
    } else {
      return $r('app.string.personal_space');
    }
  }

  public static exitSpace(localId: number): void {
    log.showInfo('exitSpace invoked');
    try {
      accountManager.deactivateOsAccount(localId);
    } catch (err) {
      log.showError(`exitSpace with error ${err?.code} ${err?.message}`);
    }
  }

  public static switchSpace(localId: number): void {
    log.showInfo('switchSpace invoked');
    try {
      if (MultiSpaceSwitchOneGoCtrl.get()
        .canHandleSpaceSwitch(SWIPE_DIRECTION_LEFT, SwitchEnterpriseMultiSpaceType.STATUS_BAR)) {
        MultiSpaceSwitchOneGoCtrl.get().handle(SWIPE_DIRECTION_LEFT, SwitchEnterpriseMultiSpaceType.STATUS_BAR);
        return;
      }
    } catch (err) {
      log.showError(`switchSpace with error ${err?.code} ${err?.message}`);
    }
  }

  public static getSpacePanelUserItemConfig(account: osAccount.OsAccountInfo): IUserItemConfig {
    const style: UserItemStyle | undefined = new UserItemStyle({
      height: 57,
      margin: {
        bottom: 2
      },
    })
    const avatar: AvatarVM = new AvatarVM({
      src: UserAvatarUtils.getImgSrcFromPhoto(account.photo),
      imgSize: 32,
      badge: account.isLoggedIn,
    });
    const textStyle: UserTextStyle = new UserTextStyle({
      size: $r('sys.float.Body_L'),
      maxFontScale: MAX_FONT_SCALE,
      weight: FontWeight.Medium,
      color: $r('sys.color.font_primary'),
      maxLines: 1,
    });
    const subTextStyle: UserTextStyle = new UserTextStyle({
      size: $r('sys.float.Body_M'),
      maxFontScale: MAX_FONT_SCALE,
      weight: FontWeight.Regular,
      color: $r('sys.color.font_secondary'),
      maxLines: 1,
    });

    const spacePanelUserItemConfig: IUserItemConfig = {
      style: style,
      avatar: avatar,
      textStyle: textStyle,
      subTextStyle: subTextStyle,
      text: account.localName
    };
    return spacePanelUserItemConfig;
  }
}