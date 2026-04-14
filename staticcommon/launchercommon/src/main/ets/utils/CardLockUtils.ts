/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import CardLockManager from '../manager/CardLockManager';
import {
  AppListStyleConfig,
  CardItemInfo,
  CommonConstants,
  FormHiSysEventReporter,
  layoutConfigManager,
  MenuInfo,
  Extend1Data,
} from '../TsIndex';
import AuthUtils from './AuthUtils';
import { ShortcutMenuClickType, ClickCardShortcutMenuEvent } from './FormHiSysEventReporter';
import { FormCommonUtil } from './FormCommonUtil';
import { FormStyleConfig } from '../configs/FormStyleConfig';

const TAG = 'CardLockUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 卡片适配应用锁menuList的utils
 */
export default class CardLockUtils {
  private static mCardLockUtils: CardLockUtils;
  private cardLockManager: CardLockManager = CardLockManager.getInstance();

  private constructor() {
  }

  /**
   * 获取单例对象
   * @returns CardLockUtils
   */
  public static getInstance(): CardLockUtils {
    if (!CardLockUtils.mCardLockUtils) {
      CardLockUtils.mCardLockUtils = new CardLockUtils();
    }
    return CardLockUtils.mCardLockUtils;
  }

  /**
   * 获取应用对应的应用锁信息菜单
   * @param appInfo 应用信息
   * @returns MenuInfo
   */
  public buildAppLockMenu(formInfo: CardItemInfo): MenuInfo {
    const lockForm = new MenuInfo();
    lockForm.menuType = CommonConstants.MENU_TYPE_FIXED;
    lockForm.menuImgSrc = '/common/pics/ic_public_card_lock.svg';
    const isRelease = this.cardLockManager.getLockedCardIsReleased(formInfo.bundleName, formInfo.cardId); // 是否释放了
    lockForm.menuText = isRelease ? $r('app.string.active_card_lock') : $r('app.string.cancel_card_lock');
    lockForm.onMenuClick = (): void => {
      this.appLockMenuClick(formInfo);
    };
    return lockForm;
  }

  private appLockMenuClick(formInfo: CardItemInfo): void {
    // 打点
    const isRelease = this.cardLockManager.getLockedCardIsReleased(formInfo.bundleName, formInfo.cardId); // 是否释放了
    this.report(formInfo, isRelease ? ShortcutMenuClickType.ACTIVE_CARD_LOCK : ShortcutMenuClickType.CANCEL_CARD_LOCK);
    log.showInfo(`cardLock menu click, start Authing`);
    AuthUtils.auth()
      .then(result => {
        log.showInfo('Authenticate succeed, auth result = ' + result);
        if (result) {
          this.cardLockManager.updateCardLockStatus(formInfo);
        }
      }).catch((e: Error) => {
      log.showInfo('Authenticate failed, auth error = ' + e?.message);
    });
  }

  private report(formInfo: CardItemInfo, menuType: number): void {
    let config = layoutConfigManager.getStyleConfig(AppListStyleConfig.APP_LIST_STYLE_CONFIG, 'featureForm') as FormStyleConfig;
    let cardDimension = formInfo.cardDimension;
    let dpSize = config.mFormWidth.get(String(cardDimension)) + '*' +
    config.mFormHeight.get(String(cardDimension));
    let event: ClickCardShortcutMenuEvent = {
      packageName: formInfo.bundleName,
      area: formInfo.area ?? [],
      dpSize: dpSize,
      formId: formInfo.cardId,
      moduleName: formInfo.moduleName,
      formName: formInfo.cardName,
      menuType,
      infoType: 0,
      sourceType: Extend1Data.getCardSourceType(formInfo.extend1 ?? '') as string,
      formType: FormCommonUtil.getFormType(formInfo.gameCardInfo),
    };
    FormHiSysEventReporter.reportGoIntoCardShortcutMenu(event);
  }
}