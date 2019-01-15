//
//  xiangeceCollection.m
//  Community
//
//  Created by 未来社区 on 16/7/30.
//  Copyright © 2016年 李江. All rights reserved.
//

#import "xiangeceCollection.h"
#import "xiangceCell.h"
#import "PhotoViewController.h"
#import "ManagerReusableView.h"
#import "JKBD_Album.h"
#import "UIImageView+WebCache.h"

#define imageNamed(name) [UIImage imageNamed:name]


@interface xiangeceCollection ()<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>

@property(nonatomic,strong)UICollectionView *momentCollectionView; //视图



@property(nonatomic,strong)NSMutableArray *allArray;

@property(nonatomic,strong)NSMutableArray *indexArray; //选中数组
@property(nonatomic,strong)NSMutableDictionary *seleDIC; //选中下标
@property(nonatomic,strong)NSMutableDictionary *photoDic; //图片数据
@property(nonatomic,assign)NSInteger type; //选中标识


@end


@implementation xiangeceCollection{

    UIImageView *showView;
    UIButton * _rBtn;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"相册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //导航栏右键
    _rBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _rBtn.frame = CGRectMake(0, 0, 25,25);
    [_rBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_rBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rBtn];
    
    

    
    _type =1;

    _allArray = [[NSMutableArray alloc]init];
    _indexArray = [[NSMutableArray alloc]init];
    _seleDIC = [[NSMutableDictionary alloc]init];
    
    
    [self getAlltime:_urls];
    [self allImgAry];
    [self _initView];
    
 
    
}



#pragma mark =============创建视图

- (void)_initView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width/3.0-3,[[UIScreen mainScreen] bounds].size.width/3.0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(1.f, 1, 1.f, 1);
    
    _momentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64) collectionViewLayout:layout];
    
    _momentCollectionView.delegate = self;
    _momentCollectionView.dataSource =self;
    _momentCollectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_momentCollectionView];
    
    [_momentCollectionView registerNib:[UINib nibWithNibName:@"xiangceCell" bundle:nil] forCellWithReuseIdentifier:@"xiangceCell"];
    
    [_momentCollectionView registerNib:[UINib nibWithNibName:@"ManagerReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ManagerReusableView"];
    
    
    //背景
    showView = [[UIImageView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-46 , [[UIScreen mainScreen] bounds].size.width, 49)];
    showView.backgroundColor = [UIColor grayColor];
    showView.userInteractionEnabled = YES;
    showView.hidden = YES;
    [self.view addSubview:showView];
    
    
    UIButton *dele_btn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,showView.frame.size.width,showView.frame.size.height)];
    [dele_btn setTitle:@"删除" forState:UIControlStateNormal];
    [dele_btn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    dele_btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [dele_btn addTarget:self action:@selector(showbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:dele_btn];
    
}


#pragma mark =============事件方法
//将时间放在一起
- (void)getAlltime:(NSArray *)Ary
{
    _photoDic = [NSMutableDictionary new];
    
    //遍历
    for (JKBD_Album *model in Ary) {
        NSMutableArray *letterArr = _photoDic[model.picture_year];
        //判断数组里是否有元素，如果为nil，则实例化该数组，
        if (letterArr == nil) {
            letterArr = [[NSMutableArray alloc] init];
            [_photoDic setObject:letterArr forKey:model.picture_year];
        }
        
        [letterArr addObject:model];
    }
    
}


// 获得所有的key值并排序，并返回排好序的数组
- (NSArray *)getCityDictAllKeys
{
    //获得cityDict字典里的所有key值
    NSArray *keys = [_photoDic allKeys];
    //按升序进行排序（A B C D……）
    NSArray *ary = [keys sortedArrayUsingSelector:@selector(compare:)];
    
    //通过倒序的方法进行降序排列
    NSEnumerator *enumerator = [ary reverseObjectEnumerator];
    return  [enumerator allObjects];
}



//将图片单独排序存放

- (void)allImgAry{

//
    NSArray *keys = [self getCityDictAllKeys];//获得多有的key值

    int i = 0;


    for (NSString *keyStr in keys) {

        NSArray *array = [_photoDic objectForKey:keyStr];

        for (int a=0;a<array.count; a++) {

            JKBD_Album *model = array[a];
            model.index_num = i;
            i++;
            [_allArray addObject:model.picture_path];
        }

    }
}




- (void)rightAction:(UIButton *)btn{


    btn.selected = !btn.selected;

    
    if (btn.selected) {
      
        _type =2;
        showView.hidden = NO;
        [_rBtn setTitle:@"取消" forState:UIControlStateNormal];
        
    }else{
    
        _type=1;
        showView.hidden = YES;
        [_rBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
    [_momentCollectionView reloadData];

}




//删除
- (void)showbtnAction:(UIButton *)btn{

    UIAlertView *alerview = [[UIAlertView alloc]initWithTitle:@"是否确认删除" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alerview show];

}

//全选时间
- (void)all_btn:(UIButton *)btn{
   
    NSArray *keys = [self getCityDictAllKeys];//获得多有的key值
    NSString *keyStr = keys[btn.tag-100];
    NSArray *array = [_photoDic objectForKey:keyStr];//所有section下key值所对应的value的值
    NSString *str = _seleDIC[[NSString stringWithFormat:@"%ld",btn.tag-100]];
    
   
    if (str.length == 0) {
      
        NSLog(@"选中");
        [array enumerateObjectsUsingBlock:^(JKBD_Album *model, NSUInteger idx, BOOL * _Nonnull stop) {
            model.indexpath = [NSIndexPath indexPathForRow:idx inSection:btn.tag -100];
            [_indexArray addObject: model];
        }];
        
        [_seleDIC setObject:[NSString stringWithFormat:@"%ld",btn.tag-100] forKey:[NSString stringWithFormat:@"%ld",btn.tag-100]];
    
    }else{
    
        NSLog(@"取消");
        [array enumerateObjectsUsingBlock:^(JKBD_Album *model, NSUInteger idx, BOOL * _Nonnull stop) {
           
            [_indexArray removeObject:model];
            model.indexpath = [NSIndexPath indexPathForRow:-1 inSection:-1];
        }];
        
        [_seleDIC removeObjectForKey:[NSString stringWithFormat:@"%ld",btn.tag-100]];
    }

    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:btn.tag - 100];
    [_momentCollectionView reloadSections:indexSet];
}




#pragma mark - CollectionView ---------------------------------------
//section 的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSArray *keys = [self getCityDictAllKeys];//获得多有的key值
    return keys.count;
}
//cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    NSArray *keys = [self getCityDictAllKeys];//获得多有的key值
    NSString *keyStr = keys[section];
    NSArray *array = [_photoDic objectForKey:keyStr];//所有section下key值所对应的value的值
    return array.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"xiangceCell";
    
    xiangceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.imgview.backgroundColor = [UIColor grayColor];
    
    
    NSArray *keys = [self getCityDictAllKeys];//获得多有的key值
    NSString *keyStr = keys[indexPath.section];
    NSArray *array = [_photoDic objectForKey:keyStr];//所有section下key值所对应的value的值
    JKBD_Album *model = [array objectAtIndex:indexPath.row];
    cell.imgview.contentMode = UIViewContentModeScaleToFill;
    
  
    if([(NSString *)(model.picture_path) rangeOfString:@"http"].location !=NSNotFound) { //网络图片
   
        [cell.imgview sd_setImageWithURL:[NSURL URLWithString:model.picture_path]];//有中文须先转码
    }else{
        
        cell.imgview.image = [UIImage imageNamed:model.picture_path];
    }


    cell.sele_button.userInteractionEnabled = NO;
    

    
    
    //选中效果
    if (_type ==1) {
        cell.sele_button.hidden = YES;
    }else{
    
        cell.sele_button.hidden = NO;
        [cell.sele_button setImage:imageNamed(@"icon_normal") forState:UIControlStateNormal];
    
    }
    
    
    
    
    
    //组选 （选中一组）
    if ( [model.indexpath isEqual:indexPath]) {
        [cell.sele_button setImage:imageNamed(@"icon_hover") forState:UIControlStateNormal];
    
    }else{
        [cell.sele_button setImage:imageNamed(@"icon_normal") forState:UIControlStateNormal];
    }

    
    
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray *keys = [self getCityDictAllKeys];//获得多有的key值
    NSString *keyStr = keys[indexPath.section];
    NSArray *array = [_photoDic objectForKey:keyStr];//所有section下key值所对应的value的值
    JKBD_Album *model = [array objectAtIndex:indexPath.row];
    

    if (_type==1) {

        // 图片游览器
        PhotoViewController *photoVC = [[PhotoViewController alloc] init];
        photoVC.urls = self.allArray;
        photoVC.index = model.index_num;
        [self presentViewController:photoVC animated:YES completion:NULL];


    }else{

        if ([model.indexpath isEqual:indexPath]) {

            model.indexpath = [NSIndexPath indexPathForRow:-1 inSection:-1];
            [_indexArray removeObject:model];

        }else{

            model.indexpath = indexPath;
            [_indexArray addObject:model];

        }


        [_momentCollectionView reloadData];
    }
}

//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    ManagerReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ManagerReusableView" forIndexPath:indexPath];
    header.all_btn.tag = 100+indexPath.section;
    
 
    if(_type==1){
    
        header.all_btn.hidden  =YES;
    
    }else{
        header.all_btn.hidden  =NO;
    }
    
    
    [header.all_btn addTarget:self action:@selector(all_btn:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *keys = [self getCityDictAllKeys];//获得多有的key值
    NSString *keyStr = keys[indexPath.section];
    header.time_lab.text = keyStr;
    
    
    return header;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width, 30);
    
}





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {

        [_indexArray enumerateObjectsUsingBlock:^(JKBD_Album *obj, NSUInteger idx, BOOL * _Nonnull stop) {

            [_urls removeObject:obj];
        }];


        [_photoDic removeAllObjects];
        [_indexArray removeAllObjects];
        [_allArray removeAllObjects];
        [_seleDIC removeAllObjects];


        [self getAlltime:_urls];
        [self allImgAry];
        [_momentCollectionView reloadData];
    }
    
}





- (void)dealloc
{
    NSLog(@"试图销毁");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
