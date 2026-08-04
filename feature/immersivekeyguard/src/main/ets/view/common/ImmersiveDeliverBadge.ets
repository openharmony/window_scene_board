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
import { LengthMetrics } from '@kit.ArkUI';
import { RTLUtil } from '@ohos/componenthelper';
import { ImmersiveAodStyle, immersiveKgMgr } from '@ohos/systemuicommon';
import { CapItemId } from '../../common/constants/CapsuleLayoutStyle';
import { ImmersiveCapsuleConstants as CapConst } from '../../common/constants/ImmersiveCapsuleConstants';
import { immersiveStateHelper } from '../../common/helper/ImmersiveStateHelper';
import { SLDeliverBadgeBindState } from '../../model/data/SLDeliverBadgeBindState';

const SCENE_BOARD_IMAGE_SIZE = 54;
const SCENE_BOARD_BADGE_WIDTH = 20;
const SCENE_BOARD_BADGE_HEIGHT = 16;
const SCENE_BOARD_LEFT_RADIUS = 16;
const SCENE_BOARD_RIGHT_RADIUS = 1;
const SCENE_BOARD_OFFSET = 5;
const DEFAULT_IMAGE_SIZE = 36;
const IMAGE_WIDTH_RADIO = 0.43;
const IMAGE_HEIGHT_RADIO = 0.5;
const OPACITY = 0.3;
const AOD_OPACITY = 0.4;
const DEFAULT_RADIO = DEFAULT_IMAGE_SIZE / SCENE_BOARD_IMAGE_SIZE;


/**
 * 锁屏胶囊克隆应用角标
 */
@Component
export struct ImmersiveDeliverBadge {
  @State bindStateCtrl: SLDeliverBadgeBindState | undefined =
    immersiveStateHelper.getImmerseDeliverBadgeBindState() as SLDeliverBadgeBindState;
  /**
   * Aod显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(true);

  aboutToAppear(): void {
  }

  build() {
    Stack() {
      Column()
        .backgroundColor($r('sys.color.black'))
        .width(this.getRootWidth())
        .height(this.getRootHeight())
        .borderRadius({
          topLeft: RTLUtil.isRTL() ? this.getBadgeColumnRightRadius() : this.getBadgeColumnLeftRadius(),
          topRight: RTLUtil.isRTL() ? this.getBadgeColumnLeftRadius() : this.getBadgeColumnRightRadius(),
          bottomLeft: RTLUtil.isRTL() ? this.getBadgeColumnLeftRadius() : this.getBadgeColumnRightRadius(),
          bottomRight: RTLUtil.isRTL() ? this.getBadgeColumnRightRadius() : this.getBadgeColumnLeftRadius(),
        })
        .enabled(false)
        .opacity(this.getColumnOpacity())
      Image($r('app.media.app_icon_deliver'))
        .width(this.getBadgeWidth())
        .height(this.getBadgeHeight())
        .enabled(false)
        .draggable(false)
        .objectFit(ImageFit.Contain)
        .fillColor(this.getBadgeFillColor())
    }
    .width(this.getRootWidth())
    .height(this.getRootHeight())
    .zIndex(CapConst.CAPSULE_SMALL_MASK_ZINDEX)
    .offset({ end: LengthMetrics.vp(this.getRootROffset()), bottom: LengthMetrics.vp(this.getRootBOffset()) })
    .enabled(false)
    .alignRules({
      // 大图标，右下角对齐
      end: { anchor: CapItemId.LARGE_ICON, align: HorizontalAlign.End },
      bottom: { anchor: CapItemId.LARGE_ICON, align: VerticalAlign.Bottom }
    })
  }

  private getRootWidth(): number {
    return this.bindStateCtrl?.getBadgeRootWidth() ?? SCENE_BOARD_BADGE_WIDTH * DEFAULT_RADIO;
  }

  private getRootHeight(): number {
    return this.bindStateCtrl?.getBadgeRootHeight() ?? SCENE_BOARD_BADGE_HEIGHT * DEFAULT_RADIO;
  }

  private getBadgeWidth(): number {
    return this.bindStateCtrl?.getBadgeIconWidth() ?? SCENE_BOARD_BADGE_WIDTH * DEFAULT_RADIO * IMAGE_WIDTH_RADIO;
  }

  private getBadgeHeight(): number {
    return this.bindStateCtrl?.getBadgeIconHeight() ?? SCENE_BOARD_BADGE_HEIGHT * DEFAULT_RADIO * IMAGE_HEIGHT_RADIO;
  }

  private getBadgeColumnLeftRadius(): number {
    return this.bindStateCtrl?.getBadgeColumnLeftRadius() ?? SCENE_BOARD_LEFT_RADIUS * DEFAULT_RADIO;
  }

  private getBadgeColumnRightRadius(): number {
    return this.bindStateCtrl?.getBadgeColumnRightRadius() ?? SCENE_BOARD_RIGHT_RADIUS * DEFAULT_RADIO;
  }

  private getColumnOpacity(): number {
    if (this.aodStyle?.isAod) {
      return AOD_OPACITY;
    }
    return this.bindStateCtrl?.getOpacity() ?? OPACITY;
  }

  private getRootROffset(): number {
    return this.bindStateCtrl?.getRootROffset() ?? SCENE_BOARD_OFFSET * DEFAULT_RADIO;
  }

  private getRootBOffset(): number {
    return this.bindStateCtrl?.getRootBOffset() ?? SCENE_BOARD_OFFSET * DEFAULT_RADIO;
  }

  private getBadgeFillColor(): ResourceColor {
    if (this.aodStyle?.isAod) {
      return $r('app.color.immersive_capsule_deliver_aod_color');
    }
    return this.bindStateCtrl?.getBadgeFillColor() ?? $r('app.color.immersive_capsule_deliver_default_color');
  }
}