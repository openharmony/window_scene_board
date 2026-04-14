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

import DeviceInfo from '@ohos.deviceInfo';
import { DesktopSettingConstants, DesktopSettingViewModel } from './DesktopSettingViewModel';
import { DesktopSettingData } from './DesktopSettingData';
import { DesktopSettingPageController } from '../../controller/desktopSetting/DesktopSettingPageController';
import { DesktopSettingHiSysEventUtil } from './DesktopSettingHiSysEventUtil';
import { HdsNavDestination, HdsNavDestinationAttribute } from '@kit.UIDesignKit';
import { SmallWindowUtil } from '../../utils/SmallWindowUtil';
import { Log } from '../../aigcServiceAbility/IdlService/Log';

const TAG = 'DesktopSettingPage';
const INTERVAL_VALUE: number = 12;
const PADDING_VALUE: number = 4;
const TOP_DISTANCE: number = 95;
const DELAY_PRELOAD_TIME: number = 300;

@Component
export default struct DesktopSettingPage {
  private desktopSettingViewModel: DesktopSettingViewModel = DesktopSettingViewModel.getInstance();
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State cardMargin: number = 16;
  @State isIntelligentSignPrivacy: boolean = false;
  @Consume('isHideBackButton') isHideBackButton: boolean;

  aboutToAppear() {
    this.cardMargin = DeviceInfo.deviceType === 'phone' ? 16 : 24;
    this.desktopSettingViewModel.initDesktopSettingData(this.pageInfos);
    const desktopSettingPageController = DesktopSettingPageController.getInstance();
    desktopSettingPageController.setDesktopSettingPage(this);
    desktopSettingPageController.getIsIntelligentSignPrivacy();
    desktopSettingPageController.registerIsSignPrivacyObserver();
    // 设置-桌面和壁纸-桌面设置
    DesktopSettingHiSysEventUtil.reportSettingEnterHomeScreen();
    Log.info(TAG, 'aboutToAppear, intelligentSignState: %{public}s, isHideBackButton: %{public}s fromSearch: %{public}s',
      this.isIntelligentSignPrivacy, this.isHideBackButton, this.desktopSettingViewModel.getDeskSetParam().fromSearch);
    setTimeout(() => {
      this.desktopSettingViewModel.preloadIconEditPage();
    }, DELAY_PRELOAD_TIME);
  }

  aboutToDisappear() {
    this.desktopSettingViewModel.preferenceOffCallback();
    const desktopSettingPageController = DesktopSettingPageController.getInstance();
    desktopSettingPageController.unRegisterIsSignPrivacyObserver();
    Log.info(TAG, `aboutToDisappear`);
  }

  @Styles
  normalStateIconStyles() {
    .backgroundColor(Color.Transparent)
  }

  @Styles
  pressedStateIconStyles() {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
  }

  @Builder
  intelligentSettings() {
    Column() {
      Row() {
        Row() {
          Text($r('app.string.intelligent'))
            .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .flexShrink(1)
          Row() {
            Text(this.getIntelligentStatusName())
              .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
              .fontWeight(FontWeight.Regular)
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
              .fontFamily('HarmonyHeiTi')
              .margin({ right: 3 })
            SymbolGlyph($r('sys.symbol.chevron_right'))
              .fontSize($r('app.float.length_24'))
              .align(Alignment.Center)
              .alignSelf(ItemAlign.Center)
              .fontWeight(FontWeight.Normal)
              .fontColor([$r('sys.color.ohos_id_color_fourth')])
              .margin({ left: 4 })
          }
          .width(112)
          .justifyContent(FlexAlign.End)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        UIExtensionComponent({
          bundleName: 'com.ohos.intelligent',
          abilityName: 'SettingUIExtAbility',
          parameters: {'ability.want.params.uiExtensionType':'sys/commonUI', 'from': 'deskTopSettings'}
        })
          .accessibilityUseSamePage(AccessibilitySamePageMode.FULL_SILENT)
          .opacity(0)
          .width(0)
          .height(0)
          .visibility(Visibility.None)
      }
      .width('100%')
      .padding({ left: 9, right: 8, top: 12, bottom: 12 })
      .borderRadius($r('sys.float.corner_radius_level8'))
      .stateStyles({
        normal: this.normalStateIconStyles,
        pressed: this.pressedStateIconStyles,
      })
      .onClick(() => {
        this.pageInfos.pushPathByName('intelligentSettingPage', {} as Record<string, string>, true);
        // 设置-桌面和个性化-桌面设置-负一屏设置
        DesktopSettingHiSysEventUtil.reportSettingEnterIntelligent();
      })
      .hoverEffect(HoverEffect.Highlight)
    }
    .margin({ top: INTERVAL_VALUE })
    .padding(PADDING_VALUE)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius($r('sys.float.corner_radius_level10'))
  }

  private getIntelligentStatusName(): ResourceStr {
    return this.isIntelligentSignPrivacy ? $r('app.string.intelligent_status_on')
      : $r('app.string.intelligent_status_off');
  }

  // 桌面布局
  @Builder
  desktopLayoutSwitch() {
    Row() {
      Text($r('app.string.desktop_layout'))
        .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontWeight(FontWeight.Medium)
        .fontFamily('HarmonyHeiTi-Medium')
        .padding({ left: 12 })
    }
    .width('100%')
    .margin({ bottom: 10, top: 28 })

    Row() {
      Column() {
        Text($r('app.string.auto_align'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          .fontWeight(500)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontFamily('HarmonyHeiTi')
          .textAlign(TextAlign.Start)
          .width('100%')
        Text($r('app.string.auto_align_content'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontWeight(FontWeight.Medium)
          .fontFamily('HarmonyHeiTi-Medium')
          .margin({ top: 6 })
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .flexShrink(1)

      Toggle({ type: ToggleType.Switch, isOn: this.desktopSettingData.autoAlignStatus })
        .onChange((isOn: boolean) => {
          Log.info(TAG, `autoAlignStatus, isOn:${isOn}`);
          this.desktopSettingViewModel.savePreference(DesktopSettingConstants.AUTO_ALIGN_STATUS, isOn);
          // 桌面设置-桌面布局-自动对齐开关
          DesktopSettingHiSysEventUtil.reportSettingAutoAlignSwitch(isOn);
        })
        .hoverEffect(HoverEffect.None)
        .accessibilityLevel('yes')
    }
    .accessibilityGroup(true)
    .padding({ left: 12, right: 12, top: 14, bottom: 14 })
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius($r('sys.float.corner_radius_level10'))
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  // 图标调节
  @Builder
  iconSettingsLayout() {
    Row() {
      Text($r('app.string.icon'))
        .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontWeight(FontWeight.Medium)
        .fontFamily('HarmonyHeiTi-Medium')
        .padding({ left: 12 })
    }
    .width('100%')
    .margin({ bottom: 10, top: 28 })

    Column() {
      Row() {
        Column() {
          Text($r('app.string.icon_settings'))
            .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
            .fontWeight(500)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .fontFamily('HarmonyHeiTi')
            .textAlign(TextAlign.Start)
            .width('100%')
          Text($r('app.string.icon_settings_content'))
            .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi-Medium')
            .margin({ top: 6 })
            .textAlign(TextAlign.Start)
            .width('100%')
        }
        .flexShrink(1)

        SymbolGlyph($r('sys.symbol.chevron_right'))
          .fontSize($r('app.float.length_24'))
          .align(Alignment.Center)
          .alignSelf(ItemAlign.Center)
          .fontWeight(FontWeight.Normal)
          .fontColor([$r('sys.color.ohos_id_color_fourth')])
      }
      .accessibilityGroup(true)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 8, right: 8, top: 12, bottom: 12 })
      .borderRadius($r('sys.float.corner_radius_level8'))
      .stateStyles({
        normal: this.normalStateIconStyles,
        pressed: this.pressedStateIconStyles,
      })
      .onClick(() => {
        if (SmallWindowUtil.checkWindowSmall()) {
          SmallWindowUtil.showToast();
        } else {
          this.desktopSettingViewModel.doSendData();
        }
      })
      .hoverEffect(HoverEffect.Highlight)
    }
    .width('100%')
    .padding(PADDING_VALUE)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius($r('sys.float.corner_radius_level10'))
  }

  @Builder
  mainContent() {
    Column() {
      Scroll() {
        Column() {
          this.desktopLayoutSwitch()
          if (!this.desktopSettingViewModel.isPC()) {
            this.intelligentSettings()
            this.iconSettingsLayout()
          }
        }
        .padding({ top: 28, bottom: 14 })
      }
      .layoutWeight(1)
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.Top)
      .scrollable(ScrollDirection.Vertical).scrollBar(BarState.Off)
    }
    .padding({top: TOP_DISTANCE, left: this.cardMargin, right: this.cardMargin})
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }

  build() {
    NavDestination() {
      this.mainContent()
    }
    .onBackPressed(() => {
      return this.desktopSettingViewModel.onBackPressed(this.pageInfos);
    })
    // .titleBar({
    //   avoidLayoutSafeArea: true,
    //   content: {
    //     title: {
    //       mainTitle: $r('app.string.Desktop_setting')
    //     }
    //   }
    // })
    .title($r('app.string.Desktop_setting'))
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .hideTitleBar(false)
    .hideBackButton(this.isHideBackButton && this.desktopSettingViewModel.getDeskSetParam().fromSearch)
  }
}