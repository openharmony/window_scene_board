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

import PowerOffStyleConstants from '../common/PoweroffStyleConstants';
import { CustomContentDialog } from '@kit.ArkUI'
import { poweroffController } from '../controller/PoweroffController';
// import findNetwork from '@hms.core.findDevice.findNetwork';
import { LogDomain, Logger } from '@ohos/basicutils';

const TAG = 'PowerOffFind';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

@Component
export struct PowerOffFind {
  /**
   * 关机查找功能是否开启
   */
  @Prop isOffFindEnabled: boolean;
  /**
   * 是否展示临时关机查找
   */
  @State isShow: boolean = false;
  /**
   * 是否选中
   */
  @State isChecked: boolean = true;
  /**
   * 文本内容
   */
  @State content: Resource = $r('app.string.off_find_checkbox');
  /**
   * 文本最大放大倍数
   */
  @Prop maxFontScale: number = PowerOffStyleConstants.POWEROFF_MAX_FONT_SCALE;

  /**
   * 同步状态到关机模块
   */
  handleOffFindEnabledStatus: (status: boolean) => void = () => {
  };

  private dialogOffFindControllerConfirm: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      primaryTitle: $r('app.string.off_find_alert_dialog_title'),
      contentBuilder: () => {
        this.buildContent();
      },
      buttons: [
        {
          value: $r('app.string.off_find_no_action_confirm'),
          action: () => {
            log.showInfo(TAG, `primary Button is clicked`);
            this.isChecked = true; // 恢复选择的状态
            this.dialogOffFindControllerConfirm.close();
          },
        },
        {
          value: $r('app.string.off_find_disable_confirm'),
          action: async () => {
            const verRes = await this.disableOffFindVerification();
            log.showInfo(TAG, `the second button is clicked verificate ${verRes}`);
            if (verRes) {
              // 认证成功则关闭
              this.isOffFindEnabled = false;
              this.isShow = false;
              this.handleOffFindEnabledStatus(false);
            } else {
              // 认证失败则恢复默认选择的状态
              this.isChecked = true;
              this.isShow = true;
              this.isOffFindEnabled = true;
            }
            this.dialogOffFindControllerConfirm.close();
          }
        }]
    }),
    // 阻断三键导航控制对话框
    onWillDismiss: () => {}
  })

  @Builder
  buildContent(): void {
    Scroll() {
      Column() {
        Text($r('app.string.off_find_alert_dialog_message'))
      }
    }
    .nestedScroll({scrollForward:NestedScrollMode.PARALLEL, scrollBackward:NestedScrollMode.PARALLEL})
    .width('100%')
  }

  aboutToAppear() {
    log.showInfo(TAG, 'aboutToAppear');
    this.init();
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'aboutToDisappear');
    this.dialogOffFindControllerConfirm.close();
  }

  /**
   * 初始化
   */
  private async init(): Promise<void> {
    // 隐私空间模式下不显示
    poweroffController.isPrivacySpaceUser((isPrivacySpaceUser: boolean) => {
      if (isPrivacySpaceUser) {
        this.isShow = false;
        log.showInfo(TAG, `init none off find checkbox in privacy mode`);
        return;
      }
      this.initNotInPrivacyMode();
    });
  }

  /**
   * 调用查找网络模块的接口通知初始化支持关机查找ux
   */
  private async initNotInPrivacyMode(): Promise<void> {
    // 初始化通知查找网络, 判断是为了防止折叠后初始化状态
    if (this.isOffFindEnabled) {
      await this.initNotifyFn();
    }
    // 查询查找网络是否支持
    const queryRes = await this.isFnOffFindEnable();
    if (queryRes && this.isOffFindEnabled) {
      this.isShow = true;
      log.showInfo(TAG, `init have off find checkbox`);
    } else {
      this.isShow = false;
      log.showInfo(TAG, `init none off find checkbox queryRes: ${queryRes}, isOffFindEnabled: ${this.isOffFindEnabled}}`);
    }
  }

  /**
   * 调用查找网络模块的接口通知初始化支持关机查找ux
   */
  private async initNotifyFn(): Promise<void> {
    try {
      // await findNetwork.enableShutdownFindeeMode();
      log.showInfo(TAG, `initNotifyFn success`);
    } catch (err) {
      log.showWarn(TAG, `initNotifyFn catch error : ${err.code} ${err.message}`);
    }
  }
  /**
   * 查询查找网络模块的是否支持关机查找特性
   */
  private async isFnOffFindEnable(): Promise<boolean> {
    try {
      /*const status = await findNetwork.queryFindNetworkStatus();
      log.showInfo(TAG, `isFindNetworkEnabled ${status.isFindNetworkEnabled}` +
        ` isShutDownFindeeSupported ${status.isShutDownFindeeSupported}`);
      return ((status.isFindNetworkEnabled === true) && (status.isShutDownFindeeSupported === true));*/
    } catch (err) {
      log.showWarn(TAG, `isFnOffindEnable catch error : ${err.code} ${err.message}`);
    }
    return false;
  }

  /**
   * 调用查找网络模块的接口拉起锁屏认证,返回结果
   * true 代表认证成功或者用户未设置锁屏密码
   * false 代表认证失败
   */
  private async disableOffFindVerification(): Promise<boolean> {
    try {
      /*await findNetwork.disableShutdownFindeeMode(findNetwork.ShutdownFindeeMode.TEMPORARILY);
      log.showInfo(TAG, `disableOffFindVerification success`);
      return true;*/
    } catch (err) {
      log.showWarn(TAG, `disableOffFindVerification catch error : ${err.code} ${err.message}`);
    }
    return false;
  }

  /**
   * 更新选中状态
   */
  private handleChange(status: boolean): void {
    this.isChecked = status;
    if (!status) {
      this.dialogOffFindControllerConfirm.open();
    }
    log.showInfo(TAG, `handleChange status: ${status}`);
  }

  @Builder
  buildItem() {
    Row({ space: 12 }) {
      // 多选框
      Column() {
        Checkbox({ name: `temporary_shutdown_off_find`, group: 'checkbox_group' })
          .shape(CheckBoxShape.CIRCLE)
          .select(this.isChecked)
          .hitTestBehavior(HitTestMode.None)
          .borderRadius(80)
          .width(20)
          .height(20)
          .margin(2)
      }
      .justifyContent(FlexAlign.Start)
      .width(24)
      .height(24)
      .margin(0)

      // 文本
      Column() {
        Text(this.content)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .draggable(false)
          .textAlign(TextAlign.Start)
          .wordBreak(WordBreak.NORMAL)
          .maxFontScale(this.maxFontScale)
          .margin({ top: 3 })
      }
      .alignItems(HorizontalAlign.Start) // column内的元素左对齐
      .layoutWeight(1)
    }
    .onClick((e: ClickEvent) => {
      this.handleChange(!this.isChecked);
    })
    .alignItems(VerticalAlign.Top) // row内的元素在垂直方向置顶
    .padding({ top: 12, bottom: 12 })
  }

  build() {
    if (this.isShow && this.content) {
      this.buildItem()
    }
  }
}
