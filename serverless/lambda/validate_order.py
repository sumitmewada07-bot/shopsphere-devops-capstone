import json

def lambda_handler(event, context):    
    quantity = event.get("quantity")    
    product_id = event.get("product_id")    
    if not isinstance(quantity, int) or quantity < 1:        
        raise ValueError("quantity must be a positive integer")    
    if not isinstance(product_id, int) or product_id < 1:        
        raise ValueError("product_id must be a positive integer")    
    return {        
        "valid": True,        
        "product_id": product_id,        
        "quantity": quantity,        
        "status": "validated"    
    }