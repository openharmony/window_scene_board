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
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { StatusBarModel } from '../model/StatusBarModel';
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import { HdsNavDestination, HdsNavDestinationAttribute, HdsNavigationTitleBarOptions } from '@kit.UIDesignKit';
import { SysUIHdsNavigations } from '../common/SysUIHdsNavigations';
import { PageContext } from '@ohos/managementcomponent/src/main/ets/com/ohos/model/SystemUISettingSession';
import lazy {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { DeviceHelper } from '@ohos/managementcomponent';

const TAG = 'MetaServiceMgmtView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/* 页面标题 */
const PAGE_TITLE: Resource = $r('app.string.notifications');

@Entry
@Component
export struct MetaServiceMgmtView {
  @State statusBarModel: StatusBarModel = StatusBarModel.get();
  @State transitionType: NavigationSystemTransitionType = NavigationSystemTransitionType.DEFAULT;
  @StorageLink('navigationMode') navMode: number = AppStorage.get('navigationMode') ?? -1;
  private appInfo: ESObject = {};
  private isFromMainPage: boolean = false;
  private pageContext?: PageContext = PageStorages.getPageContext();
  private titleBarOption?: HdsNavigationTitleBarOptions;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear, ${this.appInfo?.appBundleName}`);
    this.initEnv();
  }

  private initEnv(): void {
    this.initIconBackAction();
    this.setDestinationEntryType();
    if (this.appInfo?.appBundleName) {
      this.isFromMainPage = true;
      return;
    }
    // 从应用和元服务直接拉起元服务通知管理页
    log.showInfo('LoadAppInfoFromLocalStorage');
    if (this.pageContext?.bundleInfo) {
      this.appInfo = this.pageContext.bundleInfo;
      log.showInfo('LoadAppInfoFromLocalStorage succeed');
    } else {
      log.showWarn('LocalStorageParam or bundleInfo is none');
    }
  }

  /**
   * 在PC上，没有全面适配HDS
   * 当从应用和元服务中进入元服务通知管理页时，Ability会直接load页面，不会经过HdsNavigation，此时backIcon没有绑定事件
   * 因此对于PC或QXS的PC态（isPC为true）时需要单独定义backIcon的事件
   */
  private initIconBackAction() {
    let iconBackAction: (() => void) | undefined = undefined;
    if (DeviceHelper.isPC()) {
      iconBackAction = () => {
        this.onDestinationBackPressed();
      };
    }
    // this.titleBarOption = SysUIHdsNavigations.getTitleBarOptions(PAGE_TITLE, iconBackAction);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
  }

  build() {
    // HdsNavDestination() {
    NavDestination() {
      Row().height($r('app.float.page_title_height')).margin({ top: this.statusBarModel.height })
      if (this.appInfo?.appBundleName) {
        this.buildContentView();
      }
    }
    .hideTitleBar(false)
    .hideBackButton(false)
    // .titleBar(this.titleBarOption)
    .title(PAGE_TITLE)
    .onShown(this.onDestinationShown)
    .systemTransition(this.transitionType)
    .onBackPressed(this.onDestinationBackPressed)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }

  @Builder
  buildContentView() {
    UIExtensionComponent({
      bundleName: 'com.ohos.asde',
      abilityName: 'PanelAbility',
      parameters: {
        'ability.want.params.uiExtensionType': 'sysDialog/atomicServicePanel',
        'pageName': 'NOTIFICATION_MANAGE',
        'bundleName': this.appInfo.appBundleName,
      }
    })
      .defaultFocus(true)
      .height('100%')
      .width('100%')
      .accessibilityUseSamePage(AccessibilitySamePageMode.FULL_SILENT)
      .onRelease(code => {
        log.showInfo(`${this.appInfo.appBundleName} onRelease code ${code}`);
      })
      .onResult((data) => {
        log.showInfo(`${this.appInfo.appBundleName} onResult code ${data.code}`);
      })
      .onRemoteReady((proxy: UIExtensionProxy) => {
        log.showInfo(`${this.appInfo.appBundleName} onRemoteReady success`);
      })
      .onError(error => {
        log.showWarn(`${this.appInfo.appBundleName} onError message ${error?.message}`);
        this.loadAtomicServicePanelFailedReport(this.appInfo.appBundleName, 1, error?.code);
      })
      .onReceive((data) => {
        log.showInfo(`${this.appInfo.appBundleName} onReceive ${data['action']}`);
      })
  }

  private setDestinationEntryType(): void {
    log.showInfo(`SetDestinationEntryType isLaunch2SubPage ${this.pageContext?.isLaunch2SubPage}`);
    if (this.pageContext?.isLaunch2SubPage) {
      this.transitionType = NavigationSystemTransitionType.TITLE;
    } else {
      this.transitionType = NavigationSystemTransitionType.DEFAULT;
    }
  }

  private onDestinationBackPressed = (): boolean => {
    log.showInfo('OnDestinationBackPressed. navMode: %{public}d', this.navMode);
    if (!this.isFromMainPage) {
      PageStorages.popContext();
      return this.navMode === NavigationMode.Split;
    }
    return false;
  }

  private onDestinationShown = (): void => {
    if (this.pageContext?.isFromHome) {
      this.transitionType = NavigationSystemTransitionType.DEFAULT;
    }

    /* 第一次进入是直接进入，返回主界面后再进入就不能算直接进入 */
    if (this.pageContext) {
      this.pageContext.isLaunch2SubPage = false;
    }
  }

  private async loadAtomicServicePanelFailedReport(bundleName: string, bundleType: number,
    errorCode?: number): Promise<void> {
    try {
      NtfSettingSysEventReporter.jumpToDetailsPageFailed({
        CREATOR_BUNDLE_NAME: bundleName,
        BUNDLE_TYPE: bundleType,
        ERROR_CODE: errorCode,
      });
    } catch (error) {
      log.error(`load atomic service panel failed report error: `, error);
    }
  }
}
