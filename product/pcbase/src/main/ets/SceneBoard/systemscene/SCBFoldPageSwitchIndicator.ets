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

import { PageDesktopViewModel } from '@ohos/pagedesktop';
import { FoldSwiperController } from '../../common/FoldSwiperController';
import FeatureConstants from '@ohos/pagedesktop/src/main/ets/default/common/constants/FeatureConstants';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { DesktopModifier } from '../../ui/modifier/DesktopModifier';
import PcPresetStyleConstants from '../../common/constants/PcPresentConstants';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { WallpaperModel } from '@ohos/wallpapercomponent/src/main/ets/wallpaper/model/WallpaperModel';
import StyleConstants from '../../common/constants/StyleConstants';

const TAG = 'SCBFoldPageSwitchIndicator';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const REPORT_CLICK_INDICATOR: number = 0;

@Component
export struct SCBFoldPageSwitchIndicator {
  @State isDarkColor: boolean = false;
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
  private foldSwiperController: FoldSwiperController = FoldSwiperController.getInstance();
  // 导航点间隔及数量
  private indicatorSpace: number = 0;
  private indicatorCounts: number[] = [];
  private screenSize: number[] = [];
  modifier: DesktopModifier = new DesktopModifier();

  aboutToAppear(): void {
    log.showInfo('aboutToAppear SCBFoldPageSwitchIndicator');
    this.foldSwiperController.setSwitchPageModifier(this.modifier);
    this.indicatorSpace = PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_HEIGHT -
      PcPresetStyleConstants.DEFAULT_INDICATOR_MARGIN * 2 - PcPresetStyleConstants.DEFAULT_INDICATOR_HEIGHT * 2;
    this.indicatorCounts = [0, 1];
    WallpaperModel.getInstance().registerContentColorListener(TAG, this);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisAppear SCBFoldPageSwitchIndicator');
    WallpaperModel.getInstance().unRegisterContentColorListener(TAG);
  }

  private onTouchEvent(index: number, event?: TouchEvent) {
    if (!event) {
      return;
    }
    if (event.type !== TouchType.Down) {
      return;
    }
    const page: number = this.mPageDesktopViewModel.getKeyBoardStatus();
    const indicatorMoveDistance: number = PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_HEIGHT -
      PcPresetStyleConstants.DEFAULT_INDICATOR_SWIPER_HEIGHT - PcPresetStyleConstants.DEFAULT_INDICATOR_MARGIN * 2;
    log.showInfo(`touch index ${index}, show page: ${page}`);
    if (index === 0 && page === FeatureConstants.KEYBOARD_PAGE_C) {
      HiSysEventUtil.reportSwipePage(REPORT_CLICK_INDICATOR);
      this.foldSwiperController.switchDesktop(true);
      this.modifier.attribute?.offset({
        y: 0
      });
    }
    if (index === 1 && page === FeatureConstants.KEYBOARD_PAGE_B) {
      HiSysEventUtil.reportSwipePage(REPORT_CLICK_INDICATOR);
      this.foldSwiperController.switchDesktop(false);
      this.modifier.attribute?.offset({
        y: indicatorMoveDistance
      });
    }
  }

  onContentColorChange(newContentColor: string): void {
    log.showInfo(`desktop wallerpaper changed, newContentColor is ${newContentColor}, old Color ${this.isDarkColor}`);
    if (CommonUtils.isEmpty(newContentColor)) {
      log.showInfo('contentColor is invalid');
      return;
    }
    this.isDarkColor = newContentColor === StyleConstants.BLACK;
  }

  getRegion(): Array<number> {
    const left: number = (this.screenSize[1] - PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_HEIGHT -
      PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_MARGIN_RIGHT) / this.screenSize[1];
    const right: number = (this.screenSize[1] - PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_MARGIN_RIGHT) /
      this.screenSize[1];
    const top: number = PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_MARGIN_TOP / this.screenSize[0];
    const bottom: number = (PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_MARGIN_TOP +
      PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_HEIGHT) / this.screenSize[0];
    return [left, top, right, bottom];
  }

  build() {
    Stack({ alignContent:Alignment.Top }) {
      Column({ space: this.indicatorSpace }) {
        ForEach(this.indicatorCounts, (val: number, index: number) => {
          Stack()
            .height(PcPresetStyleConstants.DEFAULT_INDICATOR_WIDTH)
            .width(PcPresetStyleConstants.DEFAULT_INDICATOR_HEIGHT)
            .backgroundColor(this.isDarkColor ? '#20000000' : '#50FFFFFF')
            .borderRadius(PcPresetStyleConstants.DEFAULT_INDICATOR_WIDTH / 2)
            .hitTestBehavior(HitTestMode.Transparent)
        })
      }
      .margin({
        top: PcPresetStyleConstants.DEFAULT_INDICATOR_MARGIN
      })
      .justifyContent(FlexAlign.Center)

      Stack()
        .hitTestBehavior(HitTestMode.Transparent)
        .borderRadius(PcPresetStyleConstants.DEFAULT_INDICATOR_WIDTH / 2)
        .width(PcPresetStyleConstants.DEFAULT_INDICATOR_WIDTH)
        .height(PcPresetStyleConstants.DEFAULT_INDICATOR_SWIPER_HEIGHT)
        .backgroundColor(this.isDarkColor ? '#80000000' : '#FFFFFF')
        .attributeModifier(this.modifier)
        .margin({
          top: PcPresetStyleConstants.DEFAULT_INDICATOR_MARGIN
        })

      Column()
        .height(PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_HEIGHT / 2)
        .width(PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_WIDTH)
        .onTouch((event?: TouchEvent) => {
          this.onTouchEvent(0, event);
        })

      Column()
        .height(PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_HEIGHT / 2)
        .width(PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_WIDTH)
        .offset({
          y: PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_HEIGHT / 2
        })
        .onTouch((event?: TouchEvent) => {
          this.onTouchEvent(1, event);
        })
    }
    .width(PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_WIDTH)
    .height(PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_HEIGHT)
    .borderRadius(PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_WIDTH / 2)
    .backgroundColor(this.isDarkColor ? '#10000000' : '#40FFFFFF')
    .padding({
      right: PcPresetStyleConstants.DEFAULT_INDICATOR_PADDING,
      left: PcPresetStyleConstants.DEFAULT_INDICATOR_PADDING
    })
  }
}