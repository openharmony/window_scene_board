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
import { describe, it, expect } from 'vitest';
import { LiveNotificationSystemParser } from './LiveNotificationSystemParser';
import { notificationSubscribe } from './notificationSubscribe';
import { LiveRichTextModel } from './LiveRichTextModel';
import { image } from './image';
import { LiveButtonModel } from './LiveButtonModel';
import { LiveCapsuleModel, LiveCapsuleTimerModel, LiveCapsuleProgressModel, LiveCapsuleTextModel } from './LiveCapsuleModel';
import { LiveCardSystemModel } from './LiveCardSystemModel';
import { LiveTimerModel } from './LiveTimerModel';
import { LiveProgressModel } from './LiveProgressModel';
import { LiveNotificationBaseParser } from './LiveNotificationBaseParser';
import { SysTypeCode } from './SysTypeCode';
import { LiveType } from './LiveType';
import { LiveButtonState } from './LiveButtonState';
import { SystemuiConstants } from './SystemuiConstants';
import { AppLifeCycleManager } from './AppLifeCycleManager';
import { NotificationUtil } from './NotificationUtil';

export default function LiveNotificationSystemParserTest() {
  // 模拟依赖
  class LiveRichTextModel {
    static parse(content: string): LiveRichTextModel {
      return { content } as LiveRichTextModel;
    }
  }

  class image {
    static PixelMap = class {};
  }

  class LiveButtonModel {
    name: string;
    hidePanel: boolean;
    text: string;
    iconResource: image.PixelMap | resourceManager.Resource;
    lightIcon: image.PixelMap;
    darkIcon: image.PixelMap;
    accessibilityText: string;
    priority: number;
    onOffState: LiveButtonState;

    constructor() {
      this.name = '';
      this.hidePanel = false;
      this.text = '';
      this.iconResource = {} as image.PixelMap;
      this.lightIcon = {} as image.PixelMap;
      this.darkIcon = {} as image.PixelMap;
      this.accessibilityText = '';
      this.priority = 0;
      this.onOffState = LiveButtonState.ON;
    }
  }

  class LiveCapsuleModel {
    title: string;
    content: string;
    button: LiveButtonModel;
    icon: image.PixelMap;
    backgroundColor: string;
    sticky: boolean;
    hideWhenRemoveSession: boolean;
    iconAnimationType: string;

    constructor() {
      this.title = '';
      this.content = '';
      this.button = new LiveButtonModel();
      this.icon = {} as image.PixelMap;
      this.backgroundColor = '';
      this.sticky = false;
      this.hideWhenRemoveSession = false;
      this.iconAnimationType = '';
    }
  }

  class LiveCapsuleTimerModel extends LiveCapsuleModel {
    timer: LiveTimerModel;
  }

  class LiveCapsuleProgressModel extends LiveCapsuleModel {
    progress: LiveProgressModel;
  }

  class LiveCapsuleTextModel extends LiveCapsuleModel {
    content: string;
  }

  class LiveCardSystemModel {
    title: string;
    content: string;
    timer: LiveTimerModel;
    progress: LiveProgressModel;
    buttons: LiveButtonModel[];
    simIconStatus: string;
    isTimerInTitle: boolean;

    constructor() {
      this.title = '';
      this.content = '';
      this.timer = {} as LiveTimerModel;
      this.progress = {} as LiveProgressModel;
      this.buttons = [];
      this.simIconStatus = '';
      this.isTimerInTitle = false;
    }
  }

  class LiveTimerModel {
    id: string;
    initialTime: number;
    isCountdown: boolean;
    isPaused: boolean;

    constructor(id: string) {
      this.id = id;
      this.initialTime = 0;
      this.isCountdown = false;
      this.isPaused = false;
    }
  }

  class LiveProgressModel {
    maxValue: number;
    currentValue: number;
    isPercentage: boolean;
    color: string;

    constructor() {
      this.maxValue = 1;
      this.currentValue = 0;
      this.isPercentage = true;
      this.color = '';
    }
  }

  class LiveNotificationBaseParser {
    static DEFAULT_DURATION = 5000;
    static MAX_DURATION = 3600000;

    ntf: any;
    request: any;
    oldNtf: any;

    constructor(postData: any, oldNtf?: any) {
      this.ntf = {};
      this.request = postData;
      this.oldNtf = oldNtf;
    }

    protected parseLiveViewCommonData(): void {
      // 实现父类方法
    }

    protected getDuration(): number {
      return LiveNotificationBaseParser.DEFAULT_DURATION;
    }
  }

  enum SysTypeCode {
    OTHER = 'OTHER',
    PHONE = 'PHONE',
    SCREEN_RECORDING = 'SCREEN_RECORDING',
    BROADCASTING_CENTER = 'BROADCASTING_CENTER',
    NAME_THAT_TUNE = 'NAME_THAT_TUNE'
  }

  enum LiveType {
    PROGRESS = 'PROGRESS',
    PICK_UP = 'PICK_UP',
    FLIGHT = 'FLIGHT',
    SCORE = 'SCORE',
    NAVIGATION = 'NAVIGATION',
    NO_LAYOUT = 'NO_LAYOUT',
    INSTANT_BANNER = 'INSTANT_BANNER'
  }

  enum LiveButtonState {
    ON = 'ON',
    OFF = 'OFF'
  }

  class SystemuiConstants {
    static PUSH_BUNDLE_NAME = 'com.example.push';
  }

  class AppLifeCycleManager {
    static instance = {
      isForeground: (uid: string) => false
    };
  }

  class NotificationUtil {
    static getOtherLiveTimeout(ntf: any): number {
      return 3600000;
    }
  }

  describe('LiveNotificationSystemParser', () => {
    let parser: LiveNotificationSystemParser;
    let postData: notificationSubscribe.SubscribeCallbackData;
    let oldNtf: any;

    beforeEach(() => {
      // 初始化postData和oldNtf
      postData = {
        request: {
          content: {
            systemLiveView: {
              typeCode: SysTypeCode.PHONE,
              title: 'Test Title',
              text: 'Test Content',
              time: {
                initialTime: 1000,
                isCountDown: true,
                isPaused: false
              },
              progress: {
                maxValue: 100,
                currentValue: 50,
                isPercentage: true
              },
              button: {
                names: ['Button1', 'Button2'],
                iconsResource: [{} as image.PixelMap, {} as image.PixelMap]
              },
              capsule: {
                title: 'Capsule Title',
                content: 'Capsule Content',
                icon: {} as image.PixelMap,
                backgroundColor: '#ffffff',
                capsuleButtons: [{} as NotificationIconButton]
              }
            },
            extraInfo: {
              openharmony_customer_accessibility_text: 'Accessibility Text',
              openharmony_keep_headsup_sticky: true,
              stage: 'STAGE1',
              openharmony_sim_icon_status: 'SIM1',
              openharmony_live_process_color: '#ff0000',
              openharmony_capsule_process_color: '#00ff00',
              openharmony_button_priority: [1, 2],
              openharmony_button_accessibility_text: ['Btn1', 'Btn2'],
              openharmony_button_state_on: [LiveButtonState.ON, LiveButtonState.OFF],
              openharmony_capsule_sticky: true,
              openharmony_capsule_hidden_when_terminate: true,
              openharmony_capsule_icon_animation_type: 'ANIMATION1'
            }
          },
          creatorUid: 'test_uid',
          actionButtons: [{} as NotificationIconButton]
        }
      };

      oldNtf = {
        card: {
          isSystemCard: () => true,
          timer: {} as LiveTimerModel,
          progress: {} as LiveProgressModel,
          buttons: [{} as LiveButtonModel]
        },
        capsule: {
          isTimer: () => true,
          timer: {} as LiveTimerModel,
          icon: {} as image.PixelMap
        }
      };

      parser = new LiveNotificationSystemParser(postData, oldNtf);
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

    // 测试parseLiveViewCommonData方法
    describe('parseLiveViewCommonData', () => {
      it('should set typeCode and customerAccessibilityText correctly', () => {
        parser.parseLiveViewCommonData();
        expect(parser.ntf.typeCode).toBe(SysTypeCode.PHONE);
        expect(parser.ntf.customerAccessibilityText).toBe('Accessibility Text');
      });

      it('should handle missing systemLiveView', () => {
        delete postData.request.content.systemLiveView;
        parser.parseLiveViewCommonData();
        expect(parser.ntf.typeCode).toBeUndefined();
        expect(parser.ntf.customerAccessibilityText).toBeUndefined();
      });

      it('should handle missing extraInfo', () => {
        delete postData.request.extraInfo;
        parser.parseLiveViewCommonData();
        expect(parser.ntf.customerAccessibilityText).toBeUndefined();
      });
    });

    // 测试getDuration方法
    describe('getDuration', () => {
      it('should return default duration when capsule.time is not set', () => {
        delete postData.request.content.systemLiveView.capsule.time;
        expect(parser.getDuration()).toBe(LiveNotificationBaseParser.DEFAULT_DURATION);
      });

      it('should return default duration when capsule.time is less than DEFAULT_DURATION', () => {
        postData.request.content.systemLiveView.capsule.time = 3000;
        expect(parser.getDuration()).toBe(LiveNotificationBaseParser.DEFAULT_DURATION);
      });

      it('should return MAX_DURATION when capsule.time is greater than MAX_DURATION', () => {
        postData.request.content.systemLiveView.capsule.time = 4000000;
        expect(parser.getDuration()).toBe(LiveNotificationBaseParser.MAX_DURATION);
      });

      it('should return capsule.time when it is within the valid range', () => {
        postData.request.content.systemLiveView.capsule.time = 3000000;
        expect(parser.getDuration()).toBe(3000000);
      });

      it('should handle invalid capsule.time', () => {
        postData.request.content.systemLiveView.capsule.time = -1000;
        expect(parser.getDuration()).toBe(LiveNotificationBaseParser.DEFAULT_DURATION);
      });
    });

    // 测试parseCardData方法
    describe('parseCardData', () => {
      it('should parse phone card data correctly', () => {
        const result = parser.parseCardData();
        expect(result).toBeDefined();
        expect(result.title).toBe('Test Title');
        expect(result.content).toBe('Test Content');
        expect(result.simIconStatus).toBe('SIM1');
        expect(result.timer).toBeDefined();
        expect(result.progress).toBeDefined();
        expect(result.buttons).toHaveLength(2);
      });

      it('should parse screen recording card data correctly', () => {
        postData.request.content.systemLiveView.typeCode = SysTypeCode.SCREEN_RECORDING;
        const result = parser.parseCardData();
        expect(result).toBeDefined();
        expect(result.title).toBe('Test Title');
        expect(result.content).toBe('Test Content');
        expect(result.simIconStatus).toBeUndefined();
        expect(result.timer).toBeDefined();
        expect(result.progress).toBeDefined();
        expect(result.buttons).toHaveLength(2);
      });
      it('should handle missing systemLiveView', () => {
        delete postData.request.content.systemLiveView;
        const result = parser.parseCardData();
        expect(result).toBeDefined();
        expect(result.title).toBe('');
        expect(result.content).toBe('');
        expect(result.timer).toBeUndefined();
        expect(result.progress).toBeUndefined();
        expect(result.buttons).toHaveLength(0);
      });
      it('should handle missing title and text', () => {
        delete postData.request.content.systemLiveView.title;
        delete postData.request.content.systemLiveView.text;
        const result = parser.parseCardData();
        expect(result.title).toBe('');
        expect(result.content).toBe('');
      });
    });

    // 测试parseRemindFlag方法
    describe('parseRemindFlag', () => {
      it('should set remindConfig correctly', () => {
        parser.parseRemindFlag();
        expect(parser.ntf.remindConfig.isBannerEnable()).toBe(true);
        expect(parser.ntf.isSoundEnable).toBe(true);
        expect(parser.ntf.isVibrationEnable).toBe(true);
      });
      it('should handle missing openharmony_heads_up_enable', () => {
        delete postData.request.extraInfo.openharmony_heads_up_enable;
        parser.parseRemindFlag();
        expect(parser.ntf.remindConfig.isBannerEnable()).toBe(false);
      });
      it('should handle missing openharmony_remind', () => {
        delete postData.request.extraInfo.openharmony_remind;
        parser.parseRemindFlag();
        expect(parser.ntf.remindConfig.isBannerEnable()).toBe(false);
      });
      it('should handle missing isMute', () => {
        delete postData.request.extraInfo.isMute;
        parser.parseRemindFlag();
        expect(parser.ntf.isSoundEnable).toBe(true);
        expect(parser.ntf.isVibrationEnable).toBe(true);
      });
    });

    // 测试parseTimeData方法
    describe('parseTimeData', () => {
      it('should parse time data correctly', () => {
        const cardData = new LiveCardSystemModel();
        parser.parseTimeData(cardData);
        expect(cardData.timer).toBeDefined();
        expect(cardData.timer.initialTime).toBe(1000);
        expect(cardData.timer.isCountdown).toBe(true);
        expect(cardData.timer.isPaused).toBe(false);
        expect(cardData.isTimerInTitle).toBe(true);
      });
      it('should handle missing time data', () => {
        delete postData.request.content.systemLiveView.time;
        const cardData = new LiveCardSystemModel();
        parser.parseTimeData(cardData);
        expect(cardData.timer).toBeUndefined();
        expect(cardData.isTimerInTitle).toBe(false);
      });
      it('should handle invalid time data', () => {
        postData.request.content.systemLiveView.time = {} as any;
        const cardData = new LiveCardSystemModel();
        parser.parseTimeData(cardData);
        expect(cardData.timer).toBeUndefined();
        expect(cardData.isTimerInTitle).toBe(false);
      });
    });

    // 测试parseProgressData方法
    describe('parseProgressData', () => {
      it('should parse progress data correctly', () => {
        const cardData = new LiveCardSystemModel();
        parser.parseProgressData(cardData);
        expect(cardData.progress).toBeDefined();
        expect(cardData.progress.maxValue).toBe(100);
        expect(cardData.progress.currentValue).toBe(50);
        expect(cardData.progress.isPercentage).toBe(true);
        expect(cardData.progress.color).toBe('#ff0000');
      });

      it('should handle missing progress data', () => {
        delete postData.request.content.systemLiveView.progress;
        const cardData = new LiveCardSystemModel();
        parser.parseProgressData(cardData);
        expect(cardData.progress).toBeUndefined();
      });

      it('should handle invalid progress data', () => {
        postData.request.content.systemLiveView.progress = {} as any;
        const cardData = new LiveCardSystemModel();
        parser.parseProgressData(cardData);
        expect(cardData.progress).toBeDefined();
        expect(cardData.progress.maxValue).toBe(1);
        expect(cardData.progress.currentValue).toBe(0);
        expect(cardData.progress.isPercentage).toBe(true);
        expect(cardData.progress.color).toBeUndefined();
      });
    });

    // 测试parseButtonData方法
    describe('parseButtonData', () => {
      it('should parse button data correctly', () => {
        const cardData = new LiveCardSystemModel();
        parser.parseButtonData(cardData);
        expect(cardData.buttons).toHaveLength(2);
        expect(cardData.buttons[0].name).toBe('Button1');
        expect(cardData.buttons[1].name).toBe('Button2');
        expect(cardData.buttons[0].priority).toBe(1);
        expect(cardData.buttons[1].priority).toBe(2);
        expect(cardData.buttons[0].accessibilityText).toBe('Btn1');
        expect(cardData.buttons[1].accessibilityText).toBe('Btn2');
        expect(cardData.buttons[0].onOffState).toBe(LiveButtonState.ON);
        expect(cardData.buttons[1].onOffState).toBe(LiveButtonState.OFF);
      });
    });
  });
}