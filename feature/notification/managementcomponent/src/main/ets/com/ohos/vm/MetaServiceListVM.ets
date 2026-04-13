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
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
// import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import {
  LogDomain,
  LogHelper,
  NotificationConfigBaseManager,
  NotificationConfigEvent,
  NotificationConfigEventType,
  SingletonHelper,
} from '../common/BasicCommon';
import { ContextManager } from '../manager/ContextManager';
import { ToastType, ToastUtil } from '../common/ToastUtil';
import { ResourceUtil } from '../common/ResourceUtil';
import { AppItem } from './appLstComponentViewModel';
import { MetaServiceListLoader } from '../manager/MetaServiceListLoader';

const TAG = 'ManagementComponent-MetaServiceListVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const subscribeAccountInfo: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    commonEventManager.Support.COMMON_EVENT_DISTRIBUTED_ACCOUNT_LOGIN,
    commonEventManager.Support.COMMON_EVENT_DISTRIBUTED_ACCOUNT_LOGOUT,
  ]
};

@Observed
export class MetaServiceStateVM {
  public static get = SingletonHelper.createFactory(() => new MetaServiceStateVM());
  @Track public isLoadProcessVisible: boolean = true;
  @Track public isLoginAccount: boolean = false;
  @Track public isLoginLoading: boolean = false;
}

export class MetaServiceListVM {
  private metaServiceStateVM: MetaServiceStateVM = MetaServiceStateVM.get();
  private metaServiceListLoader: MetaServiceListLoader = MetaServiceListLoader.get();
  private notificationManager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
  private accountSubscriber?: commonEventManager.CommonEventSubscriber;
  private callback?: (appList: AppItem[]) => void;
  public hasLoadedMetaServiceList: boolean = false;

  init(callback: (bundleInfoList: AppItem[]) => void): void {
    this.callback = callback;
    this.notificationManager.subscribeChangeEvent(this.onNotificationConfigChange);
    this.getHuaweiIDState();
    this.subscribeAccountEvent();
  }

  destroy(): void {
    this.callback = undefined;
    this.notificationManager.unsubscribeChangeEvent(this.onNotificationConfigChange);
    this.unsubscribeAccountEvent();
  }

  private onNotificationConfigChange = async (event: NotificationConfigEvent): Promise<void> => {
    if (!this.callback) {
      return;
    }
    log.showInfo(`Recieve config event: ${event.type}`);
    if (event.type === NotificationConfigEventType.DELETE_ITEM) {
      await this.metaServiceListLoader.deleteItem(event.uid);
      this.refresh(false);
    } else if (event.type === NotificationConfigEventType.UPDATE_RESOURCE ||
      event.type === NotificationConfigEventType.ADD_ITEM) {
      this.refresh(true);
    } else if (event.type === NotificationConfigEventType.UPDATE_ITEM) {
      await this.metaServiceListLoader.updateItem(event.config.uid);
      this.refresh(false);
    }
  };

  public async refresh(isRefresh: boolean, isShowLoading: boolean = false): Promise<void> {
    log.showInfo(`refresh: ${isRefresh}`);
    try {
      this.metaServiceStateVM.isLoadProcessVisible = isShowLoading;
      this.callback?.(await this.metaServiceListLoader.getMetaServiceList(isRefresh));
      this.hasLoadedMetaServiceList = true;
    } catch (err) {
      log.error('Failed to refresh', err);
    } finally {
      this.metaServiceStateVM.isLoadProcessVisible = false;
    }
  }

  /**
   * 获取账号登录状态
   */
  private async getHuaweiIDState(): Promise<void> {
    log.showInfo(`getHuaweiIDState start`);
    // try {
    //   const stateRequest: authentication.StateRequest = {
    //     idType: authentication.IdType.UNION_ID,
    //     idValue: '0',
    //   };
    //   const stateResult: authentication.StateResult =
    //     await new authentication.HuaweiIDProvider().getHuaweiIDState(stateRequest);
    //   log.showInfo(`getHuaweiIDState success, state: ${stateResult.state}`);
    //   if (stateResult.state === authentication.State.UNLOGGED_IN) {
    //     this.metaServiceStateVM.isLoginAccount = false;
    //     this.metaServiceStateVM.isLoadProcessVisible = false;
    //   } else {
    //     this.metaServiceStateVM.isLoginAccount = true;
    //     this.refresh(true, true);
    //   }
    // } catch (err) {
    //   log.error(`Failed to getHuaweiIDState`, err);
    // }
  }

  /**
   * 订阅账号的登录/登出事件
   */
  private async subscribeAccountEvent(): Promise<void> {
    try {
      this.accountSubscriber = await commonEventManager.createSubscriber(subscribeAccountInfo);
      commonEventManager.subscribe(this.accountSubscriber,
        (err: BusinessError, data: commonEventManager.CommonEventData) => {
          if (err) {
            log.error(`Receive subscribe account event error. ${err.code}, message: ${err.message}`);
            return;
          }
          log.showInfo(`Receive subscribe account event success, event: ${data.event}`);
          if (data.event === commonEventManager.Support.COMMON_EVENT_DISTRIBUTED_ACCOUNT_LOGIN) {
            this.metaServiceStateVM.isLoginAccount = true;
            this.refresh(true, true);
          } else if (data.event === commonEventManager.Support.COMMON_EVENT_DISTRIBUTED_ACCOUNT_LOGOUT) {
            this.metaServiceStateVM.isLoginAccount = false;
            this.metaServiceListLoader.metaServiceCacheMap.clear();
          }
        });
    } catch (err) {
      log.error(`Failed to subscribe account event`, err);
    }
  }

  /**
   * 取消订阅账号的登录/登出事件
   */
  private unsubscribeAccountEvent(): void {
    if (this.accountSubscriber) {
      commonEventManager.unsubscribe(this.accountSubscriber);
      this.accountSubscriber = undefined;
    }
  }

  /**
   * 点击前往登录，拉起账号登录半模态页面
   */
  public onClickToLoginAccount = (): void => {
    if (this.metaServiceStateVM.isLoginLoading) {
      return;
    }
    log.showInfo(`onClickToLoginAccount start`);
    try {
      // this.metaServiceStateVM.isLoginLoading = true;
      // // 创建登录请求，并设置参数
      // const loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
      // // 用户是否需要登录授权，该值为true且用户未登录或未授权时，会拉起用户登录或授权页面
      // loginRequest.forceLogin = true;
      // // 用于防跨站点请求伪造
      // loginRequest.state = util.generateRandomUUID();
      //
      // const controller = new authentication.AuthenticationController(ContextManager.getContext());
      // controller.executeRequest(loginRequest).then((response: authentication.LoginWithHuaweiIDResponse) => {
      //   this.metaServiceStateVM.isLoginLoading = false;
      //   const state = response.state;
      //   if (state && loginRequest.state !== state) {
      //     log.showInfo(`executeRequest failed ${state}`);
      //     this.loginHuaweiAccountReport(0);
      //     return;
      //   }
      //   log.showInfo(`executeRequest success`);
      //   this.loginHuaweiAccountReport(1);
      // }).catch((err: BusinessError) => {
      //   log.error(`Failed to executeRequest`, err);
      //   this.metaServiceStateVM.isLoginLoading = false;
      //   if (err?.code === 1001502005) {
      //     ToastUtil.showToast({
      //       message: ResourceUtil.getStringSync($r('app.string.network_error')) ?? '',
      //     }, ToastType.DEFAULT);
      //   }
      //   this.loginHuaweiAccountReport(0, err?.code);
      // });
    } catch (err) {
      log.error(`Failed to onClickToLoginAccount`, err);
      this.metaServiceStateVM.isLoginLoading = false;
      this.loginHuaweiAccountReport(0, err?.code);
    }
  };

  private async loginHuaweiAccountReport(loginState: 0 | 1, errorCode?: number): Promise<void> {
    try {
      const lazyLoader = await import('../common/NtfSettingSysEventReporter');
      lazyLoader?.NtfSettingSysEventReporter?.metaServiceToLoginAccount({
        LOGIN_STATE: loginState,
        ERROR_CODE: errorCode,
      });
    } catch (err) {
      log.error(`loginHuaweiAccountReport error: `, err);
    }
  }
}
