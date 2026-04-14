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
import { describe, it, expect } from 'vitest';
import { LiveNotificationOtherParser } from './LiveNotificationOtherParser';
import { notificationSubscribe } from './notificationSubscribe';
import { LiveRichTextModel } from './LiveRichTextModel';
import { image } from './image';

export default function LiveNotificationOtherParserTest() {
  // 模拟依赖
  class LiveRichTextModel {
    static parse(content: string): LiveRichTextModel {
      return { content } as LiveRichTextModel;
    }
  }

  class image {
    static PixelMap = class {};
  }

  describe('LiveNotificationOtherParser', () => {
    let parser: LiveNotificationOtherParser;
    let postData: notificationSubscribe.SubscribeCallbackData;
    let oldNtf: any;

    beforeEach(() => {
      // 初始化postData和oldNtf
      postData = {
        request: {
          content: {
            liveView: {
              status: 1,
              extraInfo: {},
              pictureInfo: {},
              LayoutData: {
                layoutType: 'PROGRESS',
                style: 'DEFAULT'
              },
              CapsuleData: {
                type: 'TIMER',
                backgroundColor: '#ffffff',
                isContentDisplayed: true
              }
            }
          }
        }
      };

      oldNtf = {
        card: {
          isOtherCard: () => true,
          timer: undefined
        },
        capsule: {
          isTimer: () => true,
          timer: undefined,
          icon: undefined
        }
      };

      parser = new LiveNotificationOtherParser(postData, oldNtf);
    });

    // 测试parseCardData方法
    describe('parseCardData', () => {
      it('should parse progress card data correctly', () => {
        const result = parser.parseCardData();
        expect(result).toBeDefined();
        expect(result).toBeInstanceOf(LiveCardProgressModel);
        expect(result.layoutProgress).toBeDefined();
        expect(result.layoutColor).toBeDefined();
      });

      it('should parse pickup card data correctly', () => {
        postData.request.content.liveView.LayoutData.layoutType = 'PICK_UP';
        const result = parser.parseCardData();
        expect(result).toBeDefined();
        expect(result).toBeInstanceOf(LiveCardPickupModel);
        expect(result.layoutTitle).toBeDefined();
        expect(result.layoutContent).toBeDefined();
      });

      it('should parse flight card data correctly', () => {
        postData.request.content.liveView.LayoutData.layoutType = 'FLIGHT';
        const result = parser.parseCardData();
        expect(result).toBeDefined();
        expect(result).toBeInstanceOf(LiveCardFlightModel);
        expect(result.layoutFirstTitle).toBeDefined();
        expect(result.layoutFirstContent).toBeDefined();
      });

      it('should parse score card data correctly', () => {
        postData.request.content.liveView.LayoutData.layoutType = 'SCORE';
        const result = parser.parseCardData();
        expect(result).toBeDefined();
        expect(result).toBeInstanceOf(LiveCardScoreModel);
        expect(result.layoutHostName).toBeDefined();
        expect(result.layoutHostScore).toBeDefined();
      });

      it('should parse navigation card data correctly', () => {
        postData.request.content.liveView.LayoutData.layoutType = 'NAVIGATION';
        const result = parser.parseCardData();
        expect(result).toBeDefined();
        expect(result).toBeInstanceOf(LiveCardNavigationModel);
        expect(result.layoutCurrentNavigationIcon).toBeDefined();
        expect(result.layoutNavigationIcons).toBeDefined();
      });

      it('should parse base card data correctly', () => {
        postData.request.content.liveView.LayoutData.layoutType = 'NO_LAYOUT';
        const result = parser.parseCardData();
        expect(result).toBeDefined();
        expect(result).toBeInstanceOf(LiveCardOtherModel);
        expect(result.fixedTitle).toBeDefined();
        expect(result.fixedContent).toBeDefined();
      });

      it('should handle missing LayoutData', () => {
        delete postData.request.content.liveView.LayoutData;
        const result = parser.parseCardData();
        expect(result).toBeUndefined();
      });

      it('should handle invalid LayoutData.layoutType', () => {
        postData.request.content.liveView.LayoutData.layoutType = 'INVALID';
        const result = parser.parseCardData();
        expect(result).toBeUndefined();
      });
    });

    // 测试parseCapsuleData方法
    describe('parseCapsuleData', () => {
      it('should parse timer capsule data correctly', () => {
        const result = parser.parseCapsuleData();
        expect(result).toBeDefined();
        expect(result).toBeInstanceOf(LiveCapsuleTimerModel);
        expect(result.timer).toBeDefined();
        expect(result.content).toBeDefined();
      });

      it('should parse progress capsule data correctly', () => {
        postData.request.content.liveView.CapsuleData.type = 'PROGRESS';
        const result = parser.parseCapsuleData();
        expect(result).toBeDefined();
        expect(result).toBeInstanceOf(LiveCapsuleProgressModel);
        expect(result.progress).toBeDefined();
        expect(result.progress.maxValue).toBe(1);
        expect(result.progress.currentValue).toBe(0);
      });

      it('should parse text capsule data correctly', () => {
        postData.request.content.liveView.CapsuleData.type = 'TEXT';
        const result = parser.parseCapsuleData();
        expect(result).toBeDefined();
        expect(result).toBeInstanceOf(LiveCapsuleTextModel);
        expect(result.title).toBeDefined();
        expect(result.content).toBeDefined();
      });

      it('should handle missing CapsuleData', () => {
        delete postData.request.content.liveView.CapsuleData;
        const result = parser.parseCapsuleData();
        expect(result).toBeUndefined();
      });

      it('should handle invalid CapsuleData.type', () => {
        postData.request.content.liveView.CapsuleData.type = 'INVALID';
        const result = parser.parseCapsuleData();
        expect(result).toBeUndefined();
      });
    });

    // 测试isEnd方法
    describe('isEnd', () => {
      it('should return true when notification is timeout', () => {
        const now = Date.now();
        const timeout = NotificationUtil.getOtherLiveTimeout(parser.ntf);
        parser.ntf.deliveryTime = now - timeout - 1000;
        expect(parser.isEnd()).toBe(true);
      });

      it('should return true when status is END', () => {
        parser.info.status = LiveStatus.END;
        expect(parser.isEnd()).toBe(true);
      });

      it('should return true when capsule status is HIDE', () => {
        parser.info['CapsuleData.status'] = LiveCapsuleStatus.HIDE;
        expect(parser.isEnd()).toBe(true);
      });

      it('should return false when notification is not ended', () => {
        expect(parser.isEnd()).toBe(false);
      });

      it('should handle missing CapsuleData.status', () => {
        delete parser.info['CapsuleData.status'];
        expect(parser.isEnd()).toBe(false);
      });

      it('should handle invalid CapsuleData.status', () => {
        parser.info['CapsuleData.status'] = 'INVALID';
        expect(parser.isEnd()).toBe(false);
      });
    });

    // 测试isShowAuthorization方法
    describe('isShowAuthorization', () => {
      it('should return true when slot is authorized', () => {
        parser.slot = { authorizedStatus: 1 };
        expect(parser.isShowAuthorization()).toBe(true);
      });

      it('should return false when slot is not authorized', () => {
        parser.slot = { authorizedStatus: 0 };
        expect(parser.isShowAuthorization()).toBe(false);
      });

      it('should return false when slot is undefined', () => {
        parser.slot = undefined;
        expect(parser.isShowAuthorization()).toBe(false);
      });
    });

    // 测试parseBaseCardData方法
    describe('parseBaseCardData', () => {
      it('should parse base card data correctly', () => {
        const cardData = new LiveCardOtherModel();
        parser.parseBaseCardData(cardData);
        expect(cardData.event).toBeDefined();
        expect(cardData.fixedTitle).toBeDefined();
        expect(cardData.fixedContent).toBeDefined();
        expect(cardData.extensionType).toBeDefined();
        expect(cardData.extensionText).toBeDefined();
      });

      it('should handle missing PrimaryData', () => {
        delete postData.request.content.liveView.extraInfo['PrimaryData'];
        const cardData = new LiveCardOtherModel();
        parser.parseBaseCardData(cardData);
        expect(cardData.fixedTitle).toBe('');
        expect(cardData.fixedContent).toBeUndefined();
      });

      it('should handle missing ExtendData', () => {
        delete postData.request.content.liveView.extraInfo['ExtendData'];
        const cardData = new LiveCardOtherModel();
        parser.parseBaseCardData(cardData);
        expect(cardData.extensionType).toBeUndefined();
        expect(cardData.extensionText).toBeUndefined();
      });
    });

    // 测试parseProgressCardData方法
    describe('parseProgressCardData', () => {
      it('should parse progress card data correctly', () => {
        const result = parser.parseProgressCardData();
        expect(result).toBeDefined();
        expect(result.layoutProgress).toBeDefined();
        expect(result.layoutColor).toBeDefined();
        expect(result.layoutBackgroundColor).toBeDefined();
        expect(result.layoutIndicatorType).toBeDefined();
        expect(result.layoutLineType).toBeDefined();
      });

      it('should handle missing ProgressLayout', () => {
        delete postData.request.content.liveView.extraInfo['ProgressLayout'];
        const result = parser.parseProgressCardData();
        expect(result).toBeDefined();
        expect(result.layoutProgress).toBeUndefined();
        expect(result.layoutColor).toBeUndefined();
      });
    });

    // 测试parsePickupCardData方法
    describe('parsePickupCardData', () => {
      it('should parse pickup card data correctly', () => {
        const result = parser.parsePickupCardData();
        expect(result).toBeDefined();
        expect(result.layoutTitle).toBeDefined();
        expect(result.layoutContent).toBeDefined();
        expect(result.layoutUnderlineColor).toBeDefined();
        expect(result.layoutProviderName).toBeDefined();
      });

      it('should handle missing PickupLayout', () => {
        delete postData.request.content.liveView.extraInfo['PickupLayout'];
        const result = parser.parsePickupCardData();
        expect(result).toBeDefined();
        expect(result.layoutTitle).toBeUndefined();
        expect(result.layoutContent).toBeUndefined();
      });
    });

    // 测试parseFlightCardData方法
    describe('parseFlightCardData', () => {
      it('should parse flight card data correctly', () => {
        const result = parser.parseFlightCardData();
        expect(result).toBeDefined();
        expect(result.layoutFirstTitle).toBeDefined();
        expect(result.layoutFirstContent).toBeDefined();
        expect(result.layoutLastTitle).toBeDefined();
        expect(result.layoutLastContent).toBeDefined();
        expect(result.layoutLastTitleSuperscript).toBeDefined();
        expect(result.layoutLastContentSuperscript).toBeDefined();
        expect(result.layoutIsDisplayHorizontalLine).toBeDefined();
        expect(result.layoutAdditionalText).toBeDefined();
        expect(result.layoutSpaceType).toBeDefined();
        expect(result.layoutSpaceText).toBeDefined();
        expect(result.layoutSpaceIconRes).toBeDefined();
      });

      it('should handle missing FlightLayout', () => {
        delete postData.request.content.liveView.extraInfo['FlightLayout'];
        const result = parser.parseFlightCardData();
        expect(result).toBeDefined();
        expect(result.layoutFirstTitle).toBeUndefined();
        expect(result.layoutFirstContent).toBeUndefined();
      });
    });

    // 测试parseScoreCardData方法
    describe('parseScoreCardData', () => {
      it('should parse score card data correctly', () => {
        const result = parser.parseScoreCardData();
        expect(result).toBeDefined();
        expect(result.layoutHostName).toBeDefined();
        expect(result.layoutHostScore).toBeDefined();
        expect(result.layoutGuestName).toBeDefined();
        expect(result.layoutGuestScore).toBeDefined();
        expect(result.layoutCompetitionDesc).toBeDefined();
        expect(result.layoutCompetitionTime).toBeDefined();
        expect(result.layoutIsDisplayHorizontalLine).toBeDefined();
      });

      it('should handle missing ScoreLayout', () => {
        delete postData.request.content.liveView.extraInfo['ScoreLayout'];
        const result = parser.parseScoreCardData();
        expect(result).toBeDefined();
        expect(result.layoutHostName).toBeUndefined();
        expect(result.layoutHostScore).toBeUndefined();
      });
    });

    // 测试parseNavigationCardData方法
    describe('parseNavigationCardData', () => {
      it('should parse navigation card data correctly', () => {
        const result = parser.parseNavigationCardData();
        expect(result).toBeDefined();
        expect(result.layoutCurrentNavigationIcon).toBeDefined();
        expect(result.layoutNavigationIcons).toBeDefined();
        expect(result.layoutIsNavigationIconsDisplayed).toBeDefined();
        expect(result.layoutIsDisplayHorizontalLine).toBeDefined();
        expect(result.layoutNavigationIconMimeType).toBeDefined();
      });

      it('should handle missing NavigationLayout', () => {
        delete postData.request.content.liveView.extraInfo['NavigationLayout'];
        const result = parser.parseNavigationCardData();
        expect(result).toBeDefined();
        expect(result.layoutCurrentNavigationIcon).toBeUndefined();
        expect(result.layoutNavigationIcons).toBeUndefined();
      });
    });

    // 测试setRawfileIcon方法
    describe('setRawfileIcon', () => {
      it('should set rawfile icon correctly', () => {
        const callback = (icons: image.PixelMap[]) => {
          expect(icons).toHaveLength(1);
          expect(icons[0]).toBeInstanceOf(image.PixelMap);
        };
        parser.setRawfileIcon('ExtendData.pic', callback, undefined);
      });

      it('should handle missing icon data', () => {
        const callback = (icons: image.PixelMap[]) => {
          expect(icons).toHaveLength(0);
        };
        parser.setRawfileIcon('ExtendData.pic', callback, undefined);
      });

      it('should handle invalid icon data', () => {
        const callback = (icons: image.PixelMap[]) => {
          expect(icons).toHaveLength(0);
        };
        parser.setRawfileIcon('ExtendData.pic', callback, 'invalid');
      });
    });

    // 测试parseLiveViewCommonData方法
    describe('parseLiveViewCommonData', () => {
      it('should set typeCode and isEnd correctly', () => {
        parser.parseLiveViewCommonData();
        expect(parser.ntf.typeCode).toBe(SysTypeCode.OTHER);
        expect(parser.ntf.isEnd).toBe(parser.isEnd());
      });
      it('should handle missing status', () => {
        delete postData.request.content.liveView.status;
        parser.parseLiveViewCommonData();
        expect(parser.ntf.isEnd).toBe(parser.isEnd());
      });
    });

    // 测试getDuration方法
    describe('getDuration', () => {
      it('should return default duration', () => {
        expect(parser.getDuration()).toBe(LiveNotificationBaseParser.DEFAULT_DURATION);
      });
    });

    // 测试parseRemindFlag方法
    describe('parseRemindFlag', () => {
      it('should set remindConfig correctly', () => {
        parser.parseRemindFlag();
        expect(parser.ntf.remindConfig.isBannerEnable()).toBe(false);
        expect(parser.ntf.remindConfig.isCapsuleFlip()).toBe(false);
      });
      it('should handle missing CapsuleData.remind', () => {
        delete parser.info['CapsuleData.remind'];
        parser.parseRemindFlag();
        expect(parser.ntf.remindConfig.isBannerEnable()).toBe(false);
        expect(parser.ntf.remindConfig.isCapsuleFlip()).toBe(false);
      });
    });

    // 测试isHeadsUp方法
    describe('isHeadsUp', () => {
      it('should return true when conditions are met', () => {
        parser.request.agentBundle = {
          bundle: SystemuiConstants.PUSH_BUNDLE_NAME
        };
        parser.info['CapsuleData.remind'] = LiveCapsuleRemindType.EXPAND;
        parser.request.creatorUid = 'test_uid';
        AppLifeCycleManager.instance.isForeground = () => false;
        expect(parser.isHeadsUp()).toBe(true);
      });

      it('should return false when conditions are not met', () => {
        parser.request.agentBundle = {
          bundle: 'invalid_bundle'
        };
        parser.info['CapsuleData.remind'] = LiveCapsuleRemindType.EXPAND;
        parser.request.creatorUid = 'test_uid';
        AppLifeCycleManager.instance.isForeground = () => true;
        expect(parser.isHeadsUp()).toBe(false);
      });

      it('should return false when CapsuleData.remind is not set', () => {
        delete parser.info['CapsuleData.remind'];
        expect(parser.isHeadsUp()).toBe(false);
      });
      it('should return false when agentBundle is not set', () => {
        parser.request.agentBundle = undefined;
        expect(parser.isHeadsUp()).toBe(false);
      });
    });

    // 测试parseTimerData方法
    describe('parseTimerData', () => {
      it('should parse timer data correctly', () => {
        const timerData = parser.parseTimerData('TimerCapsule', undefined);
        expect(timerData).toBeDefined();
        expect(timerData.endTime).toBeUndefined();
        expect(timerData.duration).toBeUndefined();
      });
      it('should handle missing TimerCapsule', () => {
        delete postData.request.content.liveView.extraInfo['TimerCapsule'];
        const timerData = parser.parseTimerData('TimerCapsule', undefined);
        expect(timerData).toBeUndefined();
      });
    });

    // 测试getIconMimeType方法
    describe('getIconMimeType', () => {
      it('should return correct mime type for image', () => {
        const mimeType = parser.getIconMimeType('NavigationLayout.currentNavigationIcon');
        expect(mimeType).toBe('image/*');
      });
      it('should return default mime type for unknown', () => {
        const mimeType = parser.getIconMimeType('unknown');
        expect(mimeType).toBe('unknown');
      });
    });

    // 测试parse方法
    describe('parse', () => {
      it('should parse all data correctly', () => {
        parser.parse();
        expect(parser.ntf).toBeDefined();
        expect(parser.ntf.typeCode).toBe(SysTypeCode.OTHER);
        expect(parser.ntf.isEnd).toBe(parser.isEnd());
        expect(parser.ntf.capsule).toBeDefined();
        expect(parser.ntf.card).toBeDefined();
      });
    });
  });
}